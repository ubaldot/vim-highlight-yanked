# vim-highlight-yanked

Highlight yanked text for Vim9.

<p align="center">
<img src="/hlyanked.gif" width="60%" height="60%">
</p>

# Configuration

```
# Default values
g:hlyanked_hlgroup = 'Visual'
g:hlyanked_timeout = 400 # [ms]
```

When you yank some new text, the newly yanked text ends up in the '1' register
and the content of the following registers is shifted by one (i.e. the content
of register 2 is moved into register 3, the content of register 3 is moved
into register 4 and so on). To disable such a behavior set:

```
g:hlyanked_save_yanks = false
```

# License

BSD-3 Clause.
