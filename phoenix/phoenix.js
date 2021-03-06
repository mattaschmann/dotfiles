/* global _ Modal Phoenix Window Screen Mouse Key Event */

Phoenix.set({
  openAtLogin: true
})

const w = Window
const s = Screen
const m = Mouse
const k = Key
const e = Event

const INCREMENT = 50
const PADDING = 0
const MOD = ['ctrl', 'shift', 'cmd']
const ALTMOD = ['ctrl', 'alt', 'shift']

const HINT_APPEARANCE = 'dark'
const HINT_BUTTON = 'space'
const HINT_CANCEL = 'escape'
const HINT_CHARS = 'FJDKSLAGHRUEIWOVNCM'

const FULL_SCREEN_TOGGLE = 'space'

// DIRECTIONS
const F  = 'fill'
const N  = 'north'
const S  = 'south'
const W  = 'west'
const E  = 'east'
const C  = 'center'
const NW = 'nw'
const NE = 'ne'
const SW = 'sw'
const SE = 'se'

// KEYS + DIRECTION MAPPINGS
const snap_dirs = {
  'up':     F,
  'left':   W,
  'right':  E,
  'down':   C,
  '[':      NW,
  ']':      NE,
  ';':      SW,
  '\'':     SE
}

const size_dirs = {
  'h': W,
  'j': S,
  'k': N,
  'l': E
}

const space_dirs = {
  ',': W,
  '.': E
}

// +---------+
// | HELPERS |
// +---------+
function curw () {
  return w.focused()
}

// Conditional key binding -- execute cb only if cond_f returns truthy
function onif (cond_f, key, modifiers, cb) {
  k.on(key, modifiers, function () {
    if (!cond_f()) return
    cb()
  })
}

// Screen prototype extension -- subtract padding
s.prototype.width = function () {
  return this.flippedVisibleFrame().width - PADDING * 2
}

s.prototype.height = function () {
  return this.flippedVisibleFrame().height - PADDING * 2
}

s.prototype.origin = function () {
  return {
    x: this.flippedVisibleFrame().x + PADDING,
    y: this.flippedVisibleFrame().y + PADDING
  }
}

function opposite (dir) {
  switch (dir) {
  case N: return S
  case S: return N
  case E: return W
  case W: return E
  case NW: return SE
  case NE: return SW
  case SW: return NE
  case SE: return NW
  }
}

// Snap a window in a given direction
w.prototype.to = function (dir) {
  var screen = this.screen()
  var frame = {}
  frame.x = screen.origin().x
  frame.y = screen.origin().y
  frame.width = (screen.width()) / 2
  frame.height = (screen.height()) / 2

  if ([E, NE, SE].includes(dir)) frame.x += screen.width() - frame.width
  if ([SE, SW].includes(dir))    frame.y += screen.height() - frame.height
  if (F === dir)                 frame.width = screen.width()
  if ([F, E, W].includes(dir))   frame.height = screen.height()
  if (C === dir) {
    frame.height = screen.height() - 2 * (screen.height() / 15)
    frame.x += (screen.width() / 4)
    frame.y += (screen.height() / 15)
  }

  this.setFrame(frame)
}

// Resize a window by coeff units in the given direction
// coeff: -n shrinks by pixels units, +n grows by n pixels.
w.prototype.resize = function (dir, coeff) {
  var frame = this.frame()

  if (dir === W)                frame.x += coeff * -1
  if (dir === N)                frame.y += coeff * -1
  if ([E, W].indexOf(dir) > -1) frame.width += coeff
  if ([N, S].indexOf(dir) > -1) frame.height += coeff

  this.setFrame(frame)
}

// Move a window to a space
w.prototype.toSpace = function (dir) {
  var curSpace = this.spaces()[0]
  var newSpace = curSpace.next()
  if (dir === W) newSpace = curSpace.previous()

  curSpace.removeWindows([this])
  newSpace.addWindows([this])
  this.focus()
}

// Toggle fullscreen
w.prototype.toggleFullScreen = function() {
  this.setFullScreen(!this.isFullScreen())
}

// Snap bindings
for (var key in snap_dirs) {
  onif(curw, key, MOD, function (dir) {
    curw().to(dir)
  }.bind(null, snap_dirs[key]))
}

// Resize bindings
for (var sdir in size_dirs) {
  onif(curw, sdir, MOD, function (dir) {
    curw().resize(dir, INCREMENT)
  }.bind(null, size_dirs[sdir]))

  onif(curw, sdir, ALTMOD, function (dir) {
    curw().resize(dir, -INCREMENT)
  }.bind(null, opposite(size_dirs[sdir])))
}

// Space direction bindings
for (var spdir in space_dirs) {
  onif(curw, spdir, MOD, function (dir) {
    curw().toSpace(dir)
  }.bind(null, space_dirs[spdir]))
}

// Fullscreen binding
onif(curw, FULL_SCREEN_TOGGLE, MOD, () => curw().toggleFullScreen())

// Hints
var hintsActive = false
var hintkeys = []
var hints = {}
var escbind = null
var bsbind = null

function cancelHints () {
  for (var activator in hints) {
    hints[activator].modal.close()
  }
  k.off(escbind)
  k.off(bsbind)
  hintkeys.map(k.off)
  hints = {}
  hintkeys = []
  hintsActive = false
}

function showHints (windows, prefix) {
  prefix = prefix || ''

  if (windows.length > HINT_CHARS.length) {
    // var partitionSize = Math.floor(windows.length / HINT_CHARS.length)
    var lists = _.toArray(_.groupBy(windows, function (win, k) {
      return k % HINT_CHARS.length
    }))
    for (var j = 0; j < HINT_CHARS.length; j++) {
      showHints(lists[j], prefix + HINT_CHARS[j])
    }
    return
  }

  windows.forEach(function (win, i) {
    var helper = ''
    if (win.app().windows().length > 1) {
      var maxLen = 60
      helper += '  |  ' + win.title().substr(0, maxLen) + (win.title().length > maxLen ? '…' : '')
    }
    var hint = buildhint(prefix + HINT_CHARS[i] + helper, win)

    var activators = Object.keys(hints)
    for (var l = 0; l < activators.length; l++) {
      var hint2 = hints[activators[l]].modal
      if (
        hint.origin.x < hint2.origin.x + hint2.frame().width + PADDING
        && hint.origin.x + hint.frame().width > hint2.origin.x - PADDING
        && hint.origin.y < hint2.origin.y + hint2.frame().height + PADDING
        && hint.origin.y + hint.frame().width > hint2.origin.y - PADDING
      ) {
        hint.origin = {
          x: hint.origin.x,
          y: hint2.origin.y + hint2.frame().height + PADDING
        }
        l = -1
      }
    }

    hints[prefix + HINT_CHARS[i]] = {
      win: win,
      modal: hint,
      position: 0,
      active: true
    }
  })
  escbind = k.on(HINT_CANCEL, [], cancelHints)
  hintsActive = true
}

k.on(HINT_BUTTON, ['shift', 'cmd'], function () {
  if (hintsActive) {
    cancelHints()
  } else {
    showHints(w.all({
      visible: true
    }))
    var sequence = ''
    HINT_CHARS.split('').forEach(function (hintchar) {
      hintkeys.push(k.on(hintchar, [], function () {
        sequence += hintchar
        for (var activator in hints) {
          var hint = hints[activator]
          if (!hint.active) continue
          if (activator[hint.position] === hintchar) {
            hint.position++
            if (hint.position === activator.length) {
              hint.win.focus()
              m.move({
                x: hint.modal.origin.x + hint.modal.frame().width / 2,
                y: s.all()[0].frame().height - hint.modal.origin.y - hint.modal.frame().height / 2
              })
              return cancelHints()
            }
            hint.modal.text = hint.modal.text.substr(1)
          } else {
            hint.modal.close()
            hint.active = false
          }
        }
      }))
    })
    bsbind = k.on('delete', [], function () {
      if (!sequence.length) cancelHints()
      var letter = sequence[sequence.length - 1]
      sequence = sequence.substr(0, sequence.length - 1)
      for (var activator in hints) {
        var hint = hints[activator]
        if (hint.active) {
          hint.position--
          hint.modal.text = letter + hint.modal.text
        } else if (activator.substr(0, sequence.length) === sequence) {
          hint.modal.show()
          hint.active = true
        }
      }
    })
  }
})

e.on('mouseDidLeftClick', cancelHints)

function buildhint (msg, win) {
  var wf = win.frame()
  var wsf = win.screen().frame()
  var modal = Modal.build({
    text: msg,
    appearance: HINT_APPEARANCE,
    icon: win.app().icon(),
    weight: 14
  })
  var mf = modal.frame()
  modal.origin = {
    x: Math.min(
      Math.max(wf.x + wf.width / 2 - mf.width / 2, wsf.x),
      wsf.x + wsf.width - mf.width
    ),
    y: Math.min(
      Math.max(s.all()[0].frame().height - (wf.y + wf.height / 2 + mf.height / 2), wsf.y),
      wsf.y + wsf.height - mf.height
    )
  }
  modal.show()
  return modal
}

Phoenix.notify('Configuration loaded.')
