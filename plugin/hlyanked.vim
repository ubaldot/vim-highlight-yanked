vim9script noclear

# Highlight yanked text.
# Maintainer: Ubaldo Tiberi
# License: same as Vim
# GetLatestVimScripts: 6069 1 :AutoInstall: hlyanked.vim

if !has('vim9script') ||  v:version < 900
    finish
endif

if exists('g:hlyanked_loaded')
    finish
endif
g:hlyanked_loaded = 1

if !exists('g:hlyanked_hlgroup')
    g:hlyanked_hlgroup = 'IncSearch'
endif

if !exists('g:hlyanked_timeout')
    g:hlyanked_timeout = 400
endif

# ----------------------------------------------------
# The real deal follows

var timer_id = -1
var match_id = -1

def HighlightYanked()
    # Remove existing timers.
    # In practice this is never needed, but still...
    if timer_id != -1
        timer_stop(timer_id)
        timer_id = -1
    endif

    # Get extremes of yanking: start = (l0, c0), end = (l1, c1)
    var l0 = line("'[")
    var c0 = col("'[")
    var l1 = line("']")
    var c1 = col("']")

    # For understanding the following regex read :h \% and mind that \_.* are
    # all characters including new lines.
    # It reads: "Take all characters, including newlines, from (l0,c0) to (l1,c1)"
    var match_pattern = $'\%{l0}l\%{c0}c\_.*\%{l1}l\%{c1}c')
    match_id = matchadd(g:hlyanked_hlgroup, match_pattern)
    timer_id = timer_start(g:hlyanked_timeout, 'RemoveHighlight')
enddef

def RemoveHighlight(timer: number)
    matchdelete(match_id)
    match_id = -1
enddef

augroup HighlightYanked
    autocmd!
    autocmd TextYankPost * if v:event.operator == 'y'
        | HighlightYanked()
        | endif
augroup END