@echo off

:GitHardResetLocalRepo
echo WARNING: This will hard reset your local repo!
pause
rem git reset --hard HEAD^^
git reset --hard HEAD^
GoTo :EOF
