cd ~/.dot-files
echo "Executing update"

unchecked_changes=`git diff-index HEAD`
if [ ! -z "$unchecked_changes" ]
then
  echo "You have changes that have not been checked in!"
  git status
  read -p "Would you like to see changes? (Y/n)" re
  if [ "$re" = "Y" ]
  then
    git diff
  fi

  read -p "Would you like to check these changes in? Enter commit message (or nothing to just pull and override):" re

  if [ ! -z "$re" ]
  then
    git add -A
    git commit -m "$re"
    git push origin master
  fi
fi

git fetch origin master
git reset --hard origin/master
sh pull.sh
cd -
