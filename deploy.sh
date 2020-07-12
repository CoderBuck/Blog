#!/bin/sh

set -e
printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"
hugo -D 

msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi

# coderbuck.github.io
cd public
git add .
git commit -m "$msg"
git push origin master

# blog
git add .
git commit -m "$msg"
git push origin master