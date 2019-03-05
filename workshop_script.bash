#!/usr/bin/bash
GIT_DIR="${HOME}/workshops/bme-git-repo-test"

#create directory and make it a git repo
mkdir $GIT_DIR --parent
cd $GIT_DIR || exit 1
git init

#Create first commit
git status #there is no changes in this directory
cat <<EOF >text_file.txt
Hello Git World!
What a fine day to learn about git!
EOF

git status #there is a modified file
git diff #there is the added line
git add text_file.txt
git status #there is a file that will be committed
git commit --message="Say Hello to the world of git!"
git status #there is no changes here

#second commit
cat <<EOF >text_file.txt
Good day Git World!
EOF
