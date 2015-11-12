#!/bin/bash
WHEREAMI="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd && echo)"
cd $WHEREAMI
TERM=$(cat term.config.txt)
$TERM --title "Text-Maze" -e $WHEREAMI/text-maze.sh