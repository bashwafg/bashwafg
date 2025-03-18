@echo off

:GitShowChangedFiles
rem git fetch origin
rem git status
git diff --name-only
GoTo :EOF
