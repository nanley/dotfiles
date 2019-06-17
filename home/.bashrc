# Avoid text from being lost upon resizing in URxvt
# Solution from https://bbs.archlinux.org/viewtopic.php?id=126027
if [ -n "$PS1" ]; then
	for (( i=0; i<$LINES; i++ )); do echo; done; clear;
fi

