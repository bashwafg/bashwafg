@echo off

:GitUndoCommitAndUnstage
rem git reset --mixed HEAD^^
git reset --mixed HEAD^
GoTo :EOF
