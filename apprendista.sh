#!/bin/bash

# Procedura per creare gif animate - 29.06.2014

# Funzioni produzione gif (infrarosso, infrarosso lungo, ir+visibile, visibile)

infrarosso () {

dataoggi=`date -d today +%Y%m%d`
dataieri=`date -d yesterday +%Y%m%d`
#dataoggi=20140626
#dataieri=20140625

# Filesystem
direttorio=/home/meteo/animazioni
if [ -d ${direttorio}/IR ]; then rm -f ${direttorio}/IR/* > /dev/null 2>&1; else mkdir ${direttorio}/IR; fi
errname=ERROR_IR_${dataoggi}.txt
errfile=${direttorio}/IR/${errname}
logname=LOG_IR_${dataoggi}.txt
logfile=${direttorio}/archivio/${logname}
fileIR="H-000-MSG3__-MSG3________-IR_087___-_________-"
fileRV="H-000-MSG3__-MSG3________-VIS008___-_________-"

# controllo l'esistenza degli step temporali e copio i files
ssh meteo@10.10.0.14 "if [ -s /var/www/html/prodottimeteo/msg1/ANIM/${errname} ]; then rm -f /var/www/html/prodottimeteo/msg1/ANIM/${errname} ]; fi"

i=21
k=0
n=0
contaframe=0
contaerr=0

while [ $i -le 23 ]; do
 if [ $i -lt 10 ]; then m="0"$i; else m=$i; fi
 for k in 00 15 30 45; do
  let contaframe++
  if [ $contaframe -lt 10 ]; then n="0"$contaframe; else n=$contaframe; fi
  scp meteo@10.10.0.14:/var/www/html/prodottimeteo/msg1/ANIM/frames/${fileIR}${dataieri}${m}${k}".GIF" ${direttorio}/IR/ > /dev/null 2>&1
  if [ -s ${direttorio}/IR/${fileIR}${dataieri}${m}${k}".GIF" ]; then
   #echo "$contaframe - ${fileIR}${dataieri}${m}${k}.GIF"
   mv ${direttorio}/IR/${fileIR}${dataieri}${m}${k}".GIF" ${direttorio}/IR/"frame${n}.gif"
   convert ${direttorio}/IR/"frame${n}.gif" +repage -gravity South -crop +0+20 ${direttorio}/IR/"frame${n}_NEW.gif"
   rm -f ${direttorio}/IR/"frame${n}.gif"
   mv ${direttorio}/IR/"frame${n}_NEW.gif" ${direttorio}/IR/"frame${n}.gif"
  else
   echo "+++++++++++++++++++++++++++++++++++++++++++" > ${errfile}
   echo "immagine IR delle ${m}:${k} del ${dataieri:6:2}/${dataieri:4:2}/${dataieri:0:4} non disponibile" >> ${errfile}
   let contaerr++
  fi
 done
 let i++
done

i=0
while [ $i -le 3 ]; do
 if [ $i -lt 10 ]; then m="0"$i; else m=$i; fi
 for k in 00 15 30 45; do
 let contaframe++
 if [ $contaframe -lt 10 ]; then n="0"$contaframe; else n=$contaframe; fi 
 scp meteo@10.10.0.14:/var/www/html/prodottimeteo/msg1/ANIM/frames/${fileIR}${dataoggi}${m}${k}".GIF" ${direttorio}/IR/ > /dev/null 2>&1
  if [ -s ${direttorio}/IR/${fileIR}${dataoggi}${m}${k}".GIF" ]; then
   # debug: echo "$contaframe - ${fileIR}${dataoggi}${m}${k}.GIF"
   mv ${direttorio}/IR/${fileIR}${dataoggi}${m}${k}".GIF" ${direttorio}/IR/"frame${n}.gif"
   convert ${direttorio}/IR/"frame${n}.gif" +repage -gravity South -crop +0+20 ${direttorio}/IR/"frame${n}_NEW.gif"
   rm -f ${direttorio}/IR/"frame${n}.gif"
   mv ${direttorio}/IR/"frame${n}_NEW.gif" ${direttorio}/IR/"frame${n}.gif"
  else
   echo "immagine IR delle ${m}:${k} del ${dataoggi:6:2}/${dataoggi:4:2}/${dataoggi:0:4} non disponibile" >> ${errfile}
   let contaerr++
  fi
 done
 let i++
done

# se mancano frames copio il file di errore ed esco, altrimenti creo l'animazione IR
if [ -s ${errfile} ] && [ $contaerr -gt 8 ]; then
 echo "troppi frames mancanti (> 8)" >> ${errfile}
 echo "+++++++++++++++++++++++++++++++++++++++++++" >> ${errfile}
 scp ${errfile} meteo@10.10.0.14:/var/www/html/prodottimeteo/msg1/ANIM/ > /dev/null 2>&1
 rm -f ${direttorio}/IR/"${fileIR}${dataoggi}*.GIF"
 rm -f ${direttorio}/IR/"frame*.gif"
 mv ${errfile} ${direttorio}/archivio/
 echo "IR ${dataoggi} NOT OK :-(" >> ${logfile}
 exit 1
else
 convert -delay 30 -loop 0 ${direttorio}/IR/frame*.gif ${direttorio}/IR/IR_${dataoggi}.gif
 scp ${direttorio}/IR/IR_${dataoggi}.gif meteo@10.10.0.14:/var/www/html/prodottimeteo/msg1/ANIM/ > /dev/null 2>&1
 cp ${direttorio}/IR/IR_${dataoggi}.gif ${direttorio}/archivio/
 gzip -f9 ${direttorio}/archivio/IR_${dataoggi}.gif 
 rm -f ${direttorio}/IR/"${fileIR}${dataoggi}*.GIF"
 echo "IR ${dataoggi} OK :-)" >> ${logfile}
fi
}

infrarosso_lungo () {

dataoggi=`date -d today +%Y%m%d`
dataieri=`date -d yesterday +%Y%m%d`
#dataoggi=20140626
#dataieri=20140625

# Filesystem
direttorio=/home/meteo/animazioni
if [ -d ${direttorio}/IR ]; then rm -f ${direttorio}/IR/* > /dev/null 2>&1; else mkdir ${direttorio}/IR; fi
errname=ERROR_IRL_${dataoggi}.txt
errfile=${direttorio}/IR/${errname}
logname=LOG_IRL_${dataoggi}.txt
logfile=${direttorio}/archivio/${logname}
fileIR="H-000-MSG3__-MSG3________-IR_087___-_________-"
fileRV="H-000-MSG3__-MSG3________-VIS008___-_________-"

# controllo l'esistenza degli step temporali e copio i files
ssh meteo@10.10.0.14 "if [ -s /var/www/html/prodottimeteo/msg1/ANIM/${errname} ]; then rm -f /var/www/html/prodottimeteo/msg1/ANIM/${errname} ]; fi"

i=21
k=0
n=0
contaframe=0
contaerr=0

while [ $i -le 23 ]; do
 if [ $i -lt 10 ]; then m="0"$i; else m=$i; fi
 for k in 00 15 30 45; do
  let contaframe++
  if [ $contaframe -lt 10 ]; then n="0"$contaframe; else n=$contaframe; fi
  scp meteo@10.10.0.14:/var/www/html/prodottimeteo/msg1/ANIM/frames/${fileIR}${dataieri}${m}${k}".GIF" ${direttorio}/IR/ > /dev/null 2>&1
  if [ -s ${direttorio}/IR/${fileIR}${dataieri}${m}${k}".GIF" ]; then
   #echo "$contaframe - ${direttorio}/IR/${fileIR}${dataieri}${m}${k}.GIF"
   mv ${direttorio}/IR/${fileIR}${dataieri}${m}${k}".GIF" ${direttorio}/IR/"frame${n}.gif"
   convert ${direttorio}/IR/"frame${n}.gif" +repage -gravity South -crop +0+20 ${direttorio}/IR/"frame${n}_NEW.gif"
   rm -f ${direttorio}/IR/"frame${n}.gif"
   mv ${direttorio}/IR/"frame${n}_NEW.gif" ${direttorio}/IR/"frame${n}.gif"
  else
   echo "+++++++++++++++++++++++++++++++++++++++++++" > ${errfile}
   echo "immagine IR delle ${m}:${k} del ${dataieri:6:2}/${dataieri:4:2}/${dataieri:0:4} non disponibile" >> ${errfile}
   let contaerr++
  fi
 done
 let i++
done

i=0
while [ $i -le 14 ]; do
 if [ $i -lt 10 ]; then m="0"$i; else m=$i; fi
 for k in 00 15 30 45; do
 let contaframe++
 if [ $contaframe -lt 10 ]; then n="0"$contaframe; else n=$contaframe; fi 
 scp meteo@10.10.0.14:/var/www/html/prodottimeteo/msg1/ANIM/frames/${fileIR}${dataoggi}${m}${k}".GIF" ${direttorio}/IR/ > /dev/null 2>&1
  if [ -s ${direttorio}/IR/${fileIR}${dataoggi}${m}${k}".GIF" ]; then
   #echo "$contaframe - ${fileIR}${dataoggi}${m}${k}.GIF"
   mv ${direttorio}/IR/${fileIR}${dataoggi}${m}${k}".GIF" ${direttorio}/IR/"frame${n}.gif"
   convert ${direttorio}/IR/"frame${n}.gif" +repage -gravity South -crop +0+20 ${direttorio}/IR/"frame${n}_NEW.gif"
   rm -f ${direttorio}/IR/"frame${n}.gif"
   mv ${direttorio}/IR/"frame${n}_NEW.gif" ${direttorio}/IR/"frame${n}.gif"
  else
   echo "immagine IR delle ${m}:${k} del ${dataoggi:6:2}/${dataoggi:4:2}/${dataoggi:0:4} non disponibile" >> ${errfile}
   let contaerr++
  fi
 done
 let i++
done

# se mancano frames copio il file di errore ed esco, altrimenti creo l'animazione IR
if [ -s ${errfile} ] && [ $contaerr -gt 12 ]; then
 echo "troppi frames mancanti (> 12)" >> ${errfile}
 echo "+++++++++++++++++++++++++++++++++++++++++++" >> ${errfile}
 scp ${errfile} meteo@10.10.0.14:/var/www/html/prodottimeteo/msg1/ANIM/ > /dev/null 2>&1
 rm -f ${direttorio}/IR/"${fileIR}${dataoggi}*.GIF"
 mv ${errfile} ${direttorio}/archivio/
 echo "IRL ${dataoggi} NOT OK :-(" >> ${logfile}
 exit 1
else
 convert -delay 20 -loop 0 ${direttorio}/IR/frame*.gif ${direttorio}/IR/IRL_${dataoggi}.gif
 scp ${direttorio}/IR/IRL_${dataoggi}.gif meteo@10.10.0.14:/var/www/html/prodottimeteo/msg1/ANIM/ > /dev/null 2>&1
 gzip -f9 ${direttorio}/IR/IRL_${dataoggi}.gif 
 mv ${direttorio}/IR/IRL_${dataoggi}.gif.gz  ${direttorio}/archivio/ 
 rm -f ${direttorio}/IR/"${fileIR}${dataoggi}*.GIF"
 rm -f ${direttorio}/IR/frame*.gif
 echo "IRL ${dataoggi} OK :-)" >> ${logfile}
fi
}

infravisibile () {

dataoggi=`date -d today +%Y%m%d`
dataieri=`date -d yesterday +%Y%m%d`
#dataoggi=20140626
#dataieri=20140625


# Filesystem
direttorio=/home/meteo/animazioni
if [ -d ${direttorio}/RV ]; then rm -f ${direttorio}/RV/* > /dev/null 2>&1; else mkdir ${direttorio}/RV; fi
errname=ERROR_IRRV_${dataoggi}.txt
errfile=${direttorio}/RV/${errname}
logname=LOG_IRRV_${dataoggi}.txt
logfile=${direttorio}/archivio/${logname}
fileIR="H-000-MSG3__-MSG3________-IR_087___-_________-"
fileRV="H-000-MSG3__-MSG3________-VIS008___-_________-"

# controllo se esiste l'animazione IR; se sì procedo con anche il RV, altrimenti mi fermo
ssh meteo@10.10.0.14 "if [ -s /var/www/html/prodottimeteo/msg1/ANIM/${errname} ]; then rm -f /var/www/html/prodottimeteo/msg1/ANIM/${errname} ]; fi"

if [ -s ${direttorio}/IR/IR_${dataoggi}.gif ]; then
 i=5
 k=0
 n=0
 contagif=`ls ${direttorio}/IR/frame*.gif | wc -w`
 contaframe=`ls ${direttorio}/IR/frame*.gif | awk -v ultimo=$contagif 'BEGIN {FS="frame"} {if (NR==ultimo) print $2}' |\
            awk 'BEGIN {FS="."} {print $1+1-1}'`

 contaerr=0
 while [ $i -le 14 ]; do
  if [ $i -lt 10 ]; then m="0"$i; else m=$i; fi
  for k in 00 15 30 45; do
   let contaframe++
   echo "****$contaframe"
   if [ $contaframe -lt 10 ]; then n="0"$contaframe; else n=$contaframe; fi
   #echo "$contaframe - ${fileRV}${dataoggi}${m}${k}.BMP"
   scp meteo@10.10.0.14:/var/www/html/prodottimeteo/msg1/ANIM/frames/${fileRV}${dataoggi}${m}${k}".BMP" ${direttorio}/RV/ > /dev/null 2>&1
   if [ -s ${direttorio}/RV/${fileRV}${dataoggi}${m}${k}".BMP" ]; then
    #convert -resize "969x681!" ${direttorio}/RV/${fileRV}${dataoggi}${m}${k}".GIF" ${direttorio}/RV/${fileRV}${dataoggi}${m}${k}"NEW.GIF"
    convert ${direttorio}/RV/${fileRV}${dataoggi}${m}${k}".BMP" ${direttorio}/RV/${fileRV}${dataoggi}${m}${k}".GIF"
    mv ${direttorio}/RV/${fileRV}${dataoggi}${m}${k}".GIF" ${direttorio}/RV/"frame${n}.gif"   
    rm -f ${direttorio}/RV/${fileRV}${dataoggi}${m}${k}".BMP"
    rm -f ${direttorio}/RV/${fileRV}${dataoggi}${m}${k}".GIF"
    convert ${direttorio}/RV/"frame${n}.gif" +repage -gravity South -crop +0+20 ${direttorio}/RV/"frame${n}_NEW.gif"
    rm -f ${direttorio}/RV/"frame${n}.gif"
    mv ${direttorio}/RV/"frame${n}_NEW.gif" ${direttorio}/RV/"frame${n}.gif"
   else
    if [ ! -s ${errfile} ]; then
     echo "+++++++++++++++++++++++++++++++++++++++++++" > ${errfile}
     echo "immagine RV delle ${m}:${k} del ${dataoggi:6:2}/${dataoggi:4:2}/${dataoggi:0:4} non disponibile" >> ${errfile}
     let contaerr++
    else
     echo "immagine RV delle ${m}:${k} del ${dataoggi:6:2}/${dataoggi:4:2}/${dataoggi:0:4} non disponibile" >> ${errfile}
     let contaerr++
    fi
   fi
  done
  let i++
 done

 # se mancano frames copio il file di errore, altrimenti creo l'animazione RV
 if [ -s ${errfile} ] && [ $contaerr -gt 12 ]; then
  echo "troppi frames mancanti (> 12)" >> ${errfile}
  echo "+++++++++++++++++++++++++++++++++++++++++++" >> ${errfile}
  scp ${errfile} meteo@10.10.0.14:/var/www/html/prodottimeteo/msg1/ANIM/ > /dev/null 2>&1
  rm -f ${direttorio}/RV/"${fileRV}${dataoggi}*.GIF"
  mv ${errfile} ${direttorio}/archivio/
  echo "IRRV ${dataoggi} NOT OK :-(" >> ${logfile}
  exit 1
 else
  cp ${direttorio}/IR/frame*.gif ${direttorio}/RV/
  convert -delay 30 -loop 0 ${direttorio}/RV/frame*.gif ${direttorio}/RV/IRRV_${dataoggi}.gif
  scp ${direttorio}/RV/IRRV_${dataoggi}.gif meteo@10.10.0.14:/var/www/html/prodottimeteo/msg1/ANIM/ > /dev/null 2>&1
  cp ${direttorio}/RV/IRRV_${dataoggi}.gif ${direttorio}/archivio/
  rm -f ${direttorio}/RV/"${fileRV}${dataoggi}*.GIF"
  echo "IRRV ${dataoggi} OK :-)" >> ${logfile}
 fi

else
 echo "++++++++++++++++++++++++++++++++++++++++++++++++++" > ${errfile}
 echo "manca l'animazione IR di ${dataieri}-${dataoggi}, quindi non proseguo con RV" >> ${errfile}
 echo "+++++++++++++++++++++++++++++++++++++++++++++++++" >> ${errfile}
 scp ${errfile} meteo@10.10.0.14:/var/www/html/prodottimeteo/msg1/ANIM/ > /dev/null 2>&1
 rm -f ${direttorio}/RV/"${fileRV}${dataoggi}*.GIF"
 mv ${errfile} ${direttorio}/archivio/
 echo "IRRV ${dataoggi} NOT OK :-(" >> ${logfile}
 exit 1
fi
}

visibile () {

dataoggi=`date -d today +%Y%m%d`
dataieri=`date -d yesterday +%Y%m%d`
#dataoggi=20140626
#dataieri=20140625

# Filesystem
direttorio=/home/meteo/animazioni
if [ -d ${direttorio}/RV ]; then rm -f ${direttorio}/RV/* > /dev/null 2>&1; else mkdir ${direttorio}/RV; fi
errname=ERROR_RV_${dataoggi}.txt
errfile=${direttorio}/RV/${errname}
logname=LOG_RV_${dataoggi}.txt
logfile=${direttorio}/archivio/${logname}
fileIR="H-000-MSG3__-MSG3________-IR_087___-_________-"
fileRV="H-000-MSG3__-MSG3________-VIS008___-_________-"

# controllo l'esistenza degli step temporali e copio i files
ssh meteo@10.10.0.14 "if [ -s /var/www/html/prodottimeteo/msg1/ANIM/${errname} ]; then rm -f /var/www/html/prodottimeteo/msg1/ANIM/${errname} ]; fi"

i=5
k=0
n=0
contaframe=0
contaerr=0

while [ $i -le 14 ]; do
 if [ $i -lt 10 ]; then m="0"$i; else m=$i; fi
 for k in 00 15 30 45; do
  let contaframe++
  if [ $contaframe -lt 10 ]; then n="0"$contaframe; else n=$contaframe; fi
  scp meteo@10.10.0.14:/var/www/html/prodottimeteo/msg1/ANIM/frames/${fileRV}${dataieri}${m}${k}".BMP" ${direttorio}/RV/ > /dev/null 2>&1
  if [ -s ${direttorio}/RV/${fileIR}${dataieri}${m}${k}".BMP" ]; then
   #echo "$contaframe - ${fileIR}${dataieri}${m}${k}.GIF"
   convert ${direttorio}/RV/${fileRV}${dataoggi}${m}${k}".BMP" ${direttorio}/RV/${fileRV}${dataoggi}${m}${k}".GIF"
   mv ${direttorio}/RV/${fileRV}${dataoggi}${m}${k}".GIF" ${direttorio}/RV/"frame${n}.gif"   
   convert ${direttorio}/RV/"frame${n}.gif" +repage -gravity South -crop +0+20 ${direttorio}/RV/"frame${n}_NEW.gif"
   rm -f ${direttorio}/RV/"frame${n}.gif"
   mv ${direttorio}/RV/"frame${n}_NEW.gif" ${direttorio}/RV/"frame${n}.gif"
  else
   echo "+++++++++++++++++++++++++++++++++++++++++++" > ${errfile}
   echo "immagine IR delle ${m}:${k} del ${dataieri:6:2}/${dataieri:4:2}/${dataieri:0:4} non disponibile" >> ${errfile}
   let contaerr++
  fi
 done
 let i++
done

# se mancano frames copio il file di errore ed esco, altrimenti creo l'animazione IR
if [ -s ${errfile} ] && [ $contaerr -gt 8 ]; then
 echo "troppi frames mancanti (> 8)" >> ${errfile}
 echo "+++++++++++++++++++++++++++++++++++++++++++" >> ${errfile}
 scp ${errfile} meteo@10.10.0.14:/var/www/html/prodottimeteo/msg1/ANIM/ > /dev/null 2>&1
 rm -f ${direttorio}/RV/"${fileIR}${dataoggi}*.GIF"
 mv ${errfile} ${direttorio}/archivio/
 echo "RV ${dataoggi} NOT OK :-(" >> ${logfile}
 exit 1
else
 convert -delay 30 -loop 0 ${direttorio}/RV/frame*.gif ${direttorio}/RV/RV_${dataoggi}.gif
 scp ${direttorio}/RV/RV_${dataoggi}.gif meteo@10.10.0.14:/var/www/html/prodottimeteo/msg1/ANIM/ > /dev/null 2>&1
 cp ${direttorio}/RV/RV_${dataoggi}.gif ${direttorio}/archivio/ 
 rm -f ${direttorio}/RV/"${fileIR}${dataoggi}*.GIF"
 echo "RV ${dataoggi} OK :-)" >> ${logfile}
fi
}

ripulisci () {

dataoggi=`date -d today +%Y%m%d`
dataieri=`date -d yesterday +%Y%m%d`
datatogli=`date -d "7 days ago" +%Y%m%d`

# Filesystem
direttorio=/home/meteo/animazioni
fileIR="H-000-MSG3__-MSG3________-IR_108___-_________-"
fileRV="H-000-MSG3__-MSG3________-HRV______-_________-"

# locale
if [ -d ${direttorio}/RV ]; then rm -f ${direttorio}/RV/* > /dev/null 2>&1; fi
if [ -d ${direttorio}/IR ]; then rm -f ${direttorio}/IR/* > /dev/null 2>&1; fi

# Apprendista
ssh meteo@10.10.0.14 "rm -f /var/www/html/prodottimeteo/msg1/ANIM/frames/${fileIR}${datatogli}.GIF" > /dev/null 2>&1
ssh meteo@10.10.0.14 "rm -f /var/www/html/prodottimeteo/msg1/ANIM/IR_${datatogli}.gif"              > /dev/null 2>&1
ssh meteo@10.10.0.14 "rm -f /var/www/html/prodottimeteo/msg1/ANIM/IRL_${datatogli}.gif"             > /dev/null 2>&1
ssh meteo@10.10.0.14 "rm -f /var/www/html/prodottimeteo/msg1/ANIM/frames/${fileRV}${datatogli}.GIF" > /dev/null 2>&1
ssh meteo@10.10.0.14 "rm -f /var/www/html/prodottimeteo/msg1/ANIM/IRRV_${datatogli}.gif"            > /dev/null 2>&1
ssh meteo@10.10.0.14 "rm -f /var/www/html/prodottimeteo/msg1/ANIM/ERROR_IR_${datatogli}.txt"        > /dev/null 2>&1
ssh meteo@10.10.0.14 "rm -f /var/www/html/prodottimeteo/msg1/ANIM/ERROR_IRL_${datatogli}.txt"       > /dev/null 2>&1
ssh meteo@10.10.0.14 "rm -f /var/www/html/prodottimeteo/msg1/ANIM/ERROR_IRRV_${datatogli}.txt"      > /dev/null 2>&1
}

# Lancio dello script

arg=$1
if [ "$arg" == "IR" ]; then
 infrarosso
elif [ "$arg" == "IRL" ]; then
 infrarosso_lungo
elif [ "$arg" == "IRRV" ]; then
 infravisibile
elif [ "$arg" == "RV" ]; then
 visibile
elif [ "$arg" == "clean" ]; then
 ripulisci
else
 echo "---------------------------------------------------"
 echo "sintassi: animate.sh [IR | RV | clean] per, risp. "
 echo "infrarossi / visibile / ripulire Apprendista; la  "
 echo "produzione dell'animazione per il visibile richie-"
 echo "de l'esistenza dell'animazione degli infrarossi"
 echo "---------------------------------------------------"
 exit 0
fi
