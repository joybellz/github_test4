#!/bin/sh
# 
##################################################################################################
# 6/25/18 - This works to remote create repo to github.com/joybellz as long as you change        # github.user to be the github user's account name.                                                #
##################################################################################################

# get user name
username=`git config github.user`
if [ "$username" = "" ]; then
	echo "Could not find username, run 'git config --global github.user <username>'"
	invalid_credentials=1
fi

# get repo name
dir_name=`basename $(pwd)`
read -p "Do you want to use '$dir_name' as a repo name?(y/n)" answer_dirname
case $answer_dirname in
  y)
	# use currently dir name as a repo name
	reponame=$dir_name
    ;;
  n)
	read -p "Enter your new repository name: " reponame
	if [ "$reponame" = "" ]; then
		reponame=$dir_name
	fi
    ;;
  *)
    ;;
esac


# create repo
echo "Creating Github repository '$reponame' ..."
curl -u $username https://api.github.com/user/repos -d '{"name":"'$reponame'"}'
echo " done."

# create .gitignore file
echo "Creating .gitignore ..."
touch .gitignore
echo " done."

# push to remote repo
echo "Pushing to remote ..."
git init
git add .
git commit -m "first commit"
git remote rm origin
git remote add origin https://github.com/$username/$reponame.git
git push -u origin master
git config branch.master.remote origin
git config branch.master.merge.refs/heads/master
git fetch
git merger master
git branch -a
echo " done. Successfully created https://github.com/$username/$reponame"

