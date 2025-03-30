> [!Note]
> 
> From Vim v9.1.1230 there is a bundled package to highlight yanked text. If you are running newer versions of Vim, then you should use the bundled package instead of this plugin. You can add the bundled package by adding `packadd! hlyank` in your `.vimrc` file. Enjoy! :) 

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

When you yank some new text, the newly yanked text ends up in the 1 register
and the content of the following registers is shifted by one (i.e. the content
of register 2 is moved into register 3, the content of register 3 is moved
into register 4 and so on). In this way you never lose previously yanked text.

To disable such a behavior set:

```
g:hlyanked_save_yanks = false
```

# License

BSD-3 Clause.
