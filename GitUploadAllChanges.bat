@echo off

:GitUploadAllChanges
git fetch origin
git status
rem git add *
git add --all
if "[%~1]" EQU "[]" ( set "_autogit_message=No commit message" ) else ( set "_autogit_message=%~1" )
git commit -m "%_autogit_message%"
git push
GoTo :EOF
