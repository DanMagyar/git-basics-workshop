#!/usr/bin/bash



if [ $# -ne 1 ];
then
  echo "FATAL: Insufficient arguments for the script"
  echo "Usage: workshop_script.bash <directory_for_workshop_git_repo>"
  echo "Example: bash workshop_script.bash ~/temp/workshops/bme-git-workshop"
  exit 1
fi

#clean up repo if exists
#DELETE_WORKSPACE=${DELETE_WORKSPACE:-}
WORKSPACE="${1}"
if [ -d "$WORKSPACE" ]; then
  if [ -z ${DELETE_WORKSPACE+x} ]; then
    echo "Fatal: ${WORKSPACE} directory exists and DELETE_WORKSPACE env variable is not set, the script now exits. If you want the content of ${WORKSPACE} to be deleted, before rerunning the script, use:
          export DELETE_WORKSPACE=true"
    exit 2
  fi
  
  echo "Deleting the content of ${WORKSPACE}"
  rm -rf ${WORKSPACE}
  echo "Creating empty directory ${WORKSPACE}"
fi


#####################   PART 1 - Repo, Working directory, HEAD, stage/add, diff, commit, log  #####################
#every directory can be a git repository
mkdir $WORKSPACE --parent
cd $WORKSPACE || exit 1
git init

# Working tree: the currently checked out snapshot of the git repo
git status #there is no changes in this directory

#Create first commit
cat <<EOF >text_file.txt
Hello Git!
EOF

git status #there is a modified file
git diff #there is the added line
git add text_file.txt
git status #there is a file that will be committed
git commit --message='Say Hello to git!'
git status #there is no changes here

#Do a trivial second commit
cat <<EOF >text_file.txt
Good day Git!
EOF
git commit --all --message='Make greeting more polite'

#Check the revisions
git log #HEAD: working tree, master: default branch referenced by HEAD
git log --graph #draw a graph made of commit parent relations
git log --graph --oneline --all # make it short

cat <<EOF >random_xkcd.txt
- Monkey tacos! I'm so random!
EOF
git stage random_xkcd.txt
git commit -m "[XKCD] Some random xkcd joke"
git log --graph --oneline --all
git diff HEAD^ HEAD
git tag random_xkcd_v1.0
git log --graph --oneline --all



#####################   PART 2 - branches, tags  #####################
git checkout -b random_xkcd
git log # HEAD now points to new branch

#append another joke
cat <<EOF >>random_xkcd.txt
----------------------------
- Make me a sandwich.
- What? Make it yourself.
- SUDO make me a sandwhich.
- Okay.
EOF
git commit -a -m "[XKCD] Describe real life sandwich making"
git log --graph --oneline --all #the branch pointed moved --> branches are mutable

cat <<EOF >>random_xkcd.txt
----------------------------
int getRandomNumber()
{
  return 4;
  //chosen by fair dice roll, guaranteed to be random
}
EOF
git commit -a -m "[XKCD] add random number generator snippet"
git log --graph --oneline --all

#go back to master branch
git checkout master
cat <<EOF >text_file.txt
Good day Git World!
Let's bring the changes from random_xkcd branch into master!
EOF
git commit -a -m "add text encouriging branch sync"
#have a look at the the diverged branches
git log --graph --oneline --all


#####################   PART 3 - merge, rebase  #####################
#merge using a dedicated branch
git checkout master -b {merged}master
git merge random_xkcd --no-edit
git log {merged}master --graph --oneline

#rebase using a dedicated branch
git checkout random_xkcd -b {rebased}random_xkcd
git rebase master
git log {rebased}random_xkcd random_xkcd --graph --oneline


#compare the rebased and merged branches --> no diff
git diff {rebased}random_xkcd {merged}master
#see what happened to master after the improvement branch got merged in --> all the changes from the improvement branch are present
git diff master {merged}master
#see what happened to the improvement branch after it
git diff random_xkcd {rebased}random_xkcd


#####################   PART 4 - RESET --hard  #####################
git checkout master -b temp
git log temp --oneline --graph

git reset --hard random_xkcd
git log temp --oneline --graph

git reset --hard random_xkcd_v1.0
git log temp --oneline --graph

#####################   OPTIONAL path - detached HEAD state #####################
#git checkout $(git rev-parse HEAD)
#cat <<EOF >text_file.txt
#This change won't be seen on any of the branches until we check it out explicitly.
#EOF
#git commit -a -m "Commit made in detached HEAD state - won't be seen among the commits of the branch graph"
#git log --oneline
#DETACHED_COMMIT_HASH=$(git rev-parse HEAD)
#git checkout master
#git log --oneline #the commit is not there
#git checkout $DETACHED_COMMIT_HASH -B master_with_lost_commit
#git log --oneline # the commit is here
#git checkout master

#####################   OPTIONAL path - reflog #####################
#git reflog #see the movement of HEAD in chronological order, good for hunting down lost commits, recover resetted/deleted branches

#####################   OPTIONAL path - very pretty log #####################
#alias prettylog='git log --full-history --all --graph --pretty=format:'\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --abbrev-commit'

#####################   OPTIONAL path - conflict on master branch #####################
#git checkout master
#cat <<EOF >>random_xkcd.txt
#- 321645646546849889899684
#EOF
#git commit -a -m "[XKCD] fix monkey tacos joke"
#git log --graph --oneline --all #the branches have diverged and will conflict
