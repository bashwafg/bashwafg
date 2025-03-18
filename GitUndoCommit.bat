@echo off

:GitUndoCommit
rem git reset --soft HEAD^^
git reset --soft HEAD^
GoTo :EOF
