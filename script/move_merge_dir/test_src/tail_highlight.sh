#!/bin/bash
# --------------------------------------------------------------------------
# Description:
#
#   same as 'tail' but only to highlight each file title
#
# History:
#
#   2014-06-25:
#
#       [shensi]: First creation.
# --------------------------------------------------------------------------

/usr/bin/tail "$@" > .tail_highlight_temp
add_color_lines.sh -f .tail_highlight_temp -c "red bold" -k "^==>"
