#!/bin/bash

startdate=2014-03-30
enddate=2014-06-01
datefull=( "2014-04-14" "2014-04-15" "2014-04-16" "2014-04-17" "2014-04-18" "2014-04-23" "2014-04-30" "2014-05-05"  "2014-05-06"  "2014-05-07"  "2014-05-08"  "2014-05-09" )
datehalf=( "2014-04-05")


sDateTs=`date -f "%Y-%m-%d" $startdate "+%s"`
eDateTs=`date -f "%Y-%m-%d" $enddate "+%s"`
dateTs=$sDateTs
offset=86400

tempdir=/Users/henrimichel/git/gh-draw-test
ghaccount=henricavalcante
ghrepo=gh-draw-test
ghbranch=master
commits=0


rm -R $tempdir
mkdir $tempdir
cd $tempdir
git clone git@github.com:$ghaccount/$ghrepo.git
cd $ghrepo
if [ "$ghbranch" != "master" ];
then
    git checkout -b $ghbranch
fi

touch love
git add --all
git commit -m 'love'

while [ "$dateTs" -le "$eDateTs" ]
do
  date=`date -f "%s" $dateTs "+%Y-%m-%d"`
  printf '%s\n' $date
  dateTs=$(($dateTs+$offset))
  echo "$date" >> love
	#touch $date
	git add --all
	git commit -m '$date'
  commits=$((commits+1))

  x=0;
  while [ $x != ${#datefull[@]} ]
  do
    if [ "$date" == "${datefull[$x]}" ];
    then
      for i in {1..128}
      do
        echo "${datefull[$x]}" >> love
        git add --all
        git commit -m '$date'
        commits=$((commits+1))
      done
    fi
    let "x = x +1"
  done 

  x=0;
  while [ $x != ${#datehalf[@]} ]
  do
    if [ "$date" == "${datehalf[$x]}" ];
    then
      for i in {1..64}
      do
        echo "${datehalf[$x]}" >> love
        git add --all
        git commit -m '$date'
        commits=$((commits+1))
      done
    fi
    let "x = x +1"
  done 

  if [ "$commits" -gt "200" ];
    then
      commits=0
      git push origin $ghbranch
    fi

done

git push origin $ghbranch
#rm -R $tempdir
