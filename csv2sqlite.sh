#!/bin/sh
i=$1
if [ ! -e $1 ]; then
echo 'usage:'
echo '  csv2sqlite.sh [XLSXFILE]'
echo 'example:'
echo '  csv2sqlite.sh ~/example.xlsx'
exit
fi
# o=$2
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