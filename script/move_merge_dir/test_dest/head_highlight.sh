#!/bin/bash
# --------------------------------------------------------------------------
# Description:
#
#   same as 'head' but only to highlight each file title
#
# History:
#
#   2014-06-25:
#
#       [shensi]: First creation.
# --------------------------------------------------------------------------

/usr/bin/head "$@" > .head_highlight_temp
add_color_lines.sh -f .head_highlight_temp -c "red bold" -k "^==>"
