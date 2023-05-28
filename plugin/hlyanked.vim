vim9script noclear

# Highlight what you yank.
# Maintainer: Ubaldo Tiberi
# License: same as Vim
# GetLatestVimScripts: 6069 1 :AutoInstall: hlyanked.vim

if !has('vim9script') ||  v:version < 900
    # Needs Vim version 9.0 and above
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

def BuildMatchPattern(l0: number, c0: number, l1: number, c1: number):
            \ list<any>
    # Say that we yanked from line 23, col 15 to line 26, col 19.
    # This function return the following list [[23, 15], 24, 25, [26, 19]]
    var match_pattern = []
    # Yank on one line
    if l0 == l1
        for c in range(c0, c1)
            add(match_pattern, [l0, c])
        endfor
    else
        # Yank on two consecutive lines
        # First line
        for c in range(c0, col('$'))
            add(match_pattern, [l0, c])
        endfor
        # Second line
        for c in range(1, c1)
            add(match_pattern, [l1, c])
        endfor
    endif

    # Yanked more than two lines (you must get the whole intermediate lines)
    if l1 - l0 >= 2
        for l in range(l0 + 1, l1 - 1)
            add(match_pattern, l)
        endfor
    endif
    return match_pattern
enddef

def HighlightYanked()
    # Remove existing timers
    # This is not really needed because the user must be very fast, but
    # still...
    if timer_id != -1
        timer_stop(timer_id)
        timer_id = -1
    endif

    # Get extremes of yanking: start = (l0, c0), end = (l1, c1)
    var l0 = line("'[")
    var c0 = col("'[")
    var l1 = line("']")
    var c1 = col("']")

    # match_pattern is of the form e.g. [[23, 1], 24, 25, [26, 19]]
    match_id = matchaddpos(g:hlyanked_hlgroup,
                \ BuildMatchPattern(l0, c0, l1, c1))
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
