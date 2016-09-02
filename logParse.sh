#!/bin/shell
now=$(date +%Y-%m-%d-%T)
xcodebuild test -project mobile.xcodeproj -scheme mobile -destination 'platform=iOS Simulator,OS=9.3,name=iPhone 6 Plus' > $now.log
headLineNum=$(awk '/========== Detailed Exception ==========/{ print NR;}' $now.log) #find a head
endLineNum=$(awk '/ failed \(/{ print NR;}' $now.log) #find end line

hNums=(${headLineNum//\ / })
eNums=(${endLineNum//\ / })

if test ${#hNums}=${#eNums}
then
  echo ${#hNums}
  count=${#eNums[@]}
  for ((i=0;i<count;i++))
    do
    # echo loop $i
      for ((n=${hNums[$i]};n<=${eNums[$i]};n++))
        do
          # num of line : echo $n
          sed "${n}q;d" $now.log >> error_$now.log
        done
    done
elif ［ ${#hNums}=0 -a [${#eNums}=0 ］
  then
    echo 'there has no error found.'
else 
  echo 'read line numbers error'
fi
tail -n 2 $now.log >> error_$now.log 
