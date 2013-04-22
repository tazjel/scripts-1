k=0
result=0
for i in `cat out.txt ` 
do
    k=$((k+1))
    result=$((k%1))
    if [ $result == 0 ]
    then
      echo -n "  $k --- $result  "
      data=`date` 
      echo -n "$i  --- $data  --- " 
      echo `curl http://www.valor.com.br$i -i -s | grep -i x-cache:`
    fi

done
