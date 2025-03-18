@echo off

:GitSetup

ssh-keygen -t ed25519 -C "github-bash-wafg@example.net"
clip < %USERPROFILE%\.ssh\id_ed25519.pub
echo goto https://github.com/settings/keys and enter text in your clipboard
pause
git config --global http.proxy http://127.0.0.1:9000
git config --global user.name "bashwafg"
git config --global user.email github-bash-wafg@example.net
git remote set-url origin git@github.com:bashwafg/bashwafg.git

git push --set-upstream origin main
GoTo :EOF
