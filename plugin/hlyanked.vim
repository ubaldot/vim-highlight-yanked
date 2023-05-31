vim9script noclear

# Highlight yanked text.
# Maintainer: Ubaldo Tiberi
# License: BSD3-Clause
# GetLatestVimScripts: 6075 1 :AutoInstall: hlyanked.vim

if !has('vim9script') ||  v:version < 900
    finish
endif

if exists('g:hlyanked_loaded')
    finish
endif
g:hlyanked_loaded = 1

if !exists('g:hlyanked_hlgroup')
    g:hlyanked_hlgroup = 'Visual'
endif

if !exists('g:hlyanked_timeout')
    g:hlyanked_timeout = 400
endif

# ----------------------------------------------------
# The real deal follows

var timer_id = -1
var match_id = -1

def HighlightYanked()
    # Remove leftover timers and highlights
    KillHighlight()

    # Get extremes of yanking: start = (l0, c0), end = (l1, c1)
    var l0 = line("'[")
    var c0 = col("'[")
    var l1 = line("']")

    var delta = 0
    if l0 == l1
        delta = len(v:event.regcontents[-1]) - (col("']") - c0)
    endif

    var c1 = col("']") + delta

    # For understanding the following regex read :h \% and mind that \_.* are
    # all characters including new lines.
    # The regex reads:
    # 'Take all characters, including newlines, from (l0,c0) to (l1,c1)'
    var match_pattern = $'\%{l0}l\%{c0}c\_.*\%{l1}l\%{c1}c'
    match_id = matchadd(g:hlyanked_hlgroup, match_pattern)
    timer_id = timer_start(g:hlyanked_timeout, 'RemoveHighlight')
enddef

def RemoveHighlight(timer: number)
    if match_id != -1
        matchdelete(match_id)
        match_id = -1
    endif
enddef

def StopTimer(timer: number)
    if timer_id != -1
        timer_stop(timer_id)
        timer_id = -1
    endif
enddef

def KillHighlight()
    StopTimer(timer_id)
    RemoveHighlight(match_id)
enddef

augroup HighlightYanked
    autocmd!
    autocmd TextYankPost * if !v:event.visual && v:event.operator == 'y' && !empty(v:event.regtype)
        | HighlightYanked()
        | endif
augroup END

augroup KillHighlight
    autocmd!
    autocmd WinLeave * KillHighlight()
augroup END
