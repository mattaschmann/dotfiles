Get all commits between specified times
---------------------------------------
```shell
git log --since "may 6 2018" --until "may 12 2018" --pretty=oneline
```

### Filter on `Merge` and pipe to nvim
```shell
git log --since "may 6 2018" --until "may 12 2018" --pretty=oneline | rg Merge | nvim -
```
