#!/bin/bash

if [ -n "$1" ]; then
    i3-input -F 'mark %s' -l 1 -P 'Mark: '
else
    i3-input -F 'unmark %s' -l 1 -P 'Mark: '
fi
i3-msg '[class=.*] title_format "%title", [con_mark=".*"] title_format "<span>   %title</span>"'
