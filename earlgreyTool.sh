#!/bin/sh
LogParse(){
  echo 'Log Parse Begin'
  path='EarlGreyToolLogs'
  if [ -d ]
  # now=$(date +%Y-%m-%d-%T)
  # xcodebuild test -project mobile.xcodeproj -scheme mobile -destination 'platform=iOS Simulator,OS=9.3,name=iPhone 6 Plus' > $now.log
  # headLineNum=$(awk '/========== Detailed Exception ==========/{ print NR;}' $now.log) #find a head
  # endLineNum=$(awk '/ failed \(/{ print NR;}' $now.log) #find end line
  # hNums=(${headLineNum//\ / })
  # eNums=(${endLineNum//\ / })
  # if ${#hNums}=${#eNums}
  # then
  #   echo ${#hNums}
  #   count=${#eNums[@]}
  #   for ((i=0;i<count;i++))
  #     do
  #     # echo loop $i
  #       for ((n=${hNums[$i]};n<=${eNums[$i]};n++))
  #         do
  #           # num of line : echo $n
  #           sed "${n}q;d" $now.log >> error_$now.log
  #         done
  #     done
  # elif ［ ${#hNums}=0 -a [${#eNums}=0 ］
  #   then
  #     echo 'there has no error found.'
  # else 
  #   echo 'read line numbers error'
  # fi
  # tail -n 2 $now.log >> error_$now.log 
}

i=$1
if [ "$1" = "run" ]; then
LogParse
exit
fi

if [ ! -e $1 ]; then
echo 'run test with xlsx'
echo '  earlgreyTool.sh [XLSXFILE]    eg. earlgreyTool.sh ~/example.xlsx ' 
echo 'run test'
echo '  earlgreyTool.sh run '
exit;
fi

xlsx2csv $1 data.csv -s 1
if [ ! $? -eq 0 ]; then
    echo 'You have not install xlsx2csv !'
    echo 'Please execute sudo easy_install xlsx2csv or pip install xlsx2csv.'
    exit
fi
sql='csv2sql.sql'
if [ -e $sql ]; then
rm -rf $sql
echo 'removed exists .sql file'
fi 
touch $sql
echo 'DROP TABLE DATA;' >> $sql
echo 'CREATE TABLE  data(caseId,dataId,inputData,expectation,mark);' >> $sql
echo '.mode csv' >> $sql
echo '.import data.csv data' >> $sql
echo "DELETE FROM data WHERE caseId='caseId';" >> $sql
echo '.header on' >> $sql
echo '.mode column' >> $sql
echo 'SELECT * FROM data;' >> $sql
sqlite3 data.sqlite < $sql
rm $sql
rm data.csv