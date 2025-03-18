@echo off

:GitCompareWithServer
git fetch origin
git log -1 HEAD
rem git log -1 origin/main
git log -1 @{u}
git rev-parse HEAD
rem git rev-parse origin/main
git rev-parse @{u}
GoTo :EOF
