### Using :diffthis to compare two buffers
_taken from: http://vimcasts.org/episodes/comparing-buffers-with-vimdiff/_

The **:diffthis** command allows us to compare two (or more) buffers that are open in an existing Vim session. If we have two split windows containing buffers that we want to compare, then we can diff them by running:

```
:windo diffthis
```

We can turn diff mode off just as easily, by running:

```
:windo diffoff
```

