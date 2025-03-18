@echo off 

:GitShowFileDiff
git fetch origin
rem git diff origin
git diff @{u}
GoTo :EOF
