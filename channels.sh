#!/bin/bash
#

#DI.FM Recupera canales y emite

#URL Servidor
URL=http://pub7.di.fm/

CHANNELS=$(curl -s  pub7.di.fm)


#Control Numero parametros
if test $# -ne 1
then
  BUSCA=di_
else
  BUSCA=$1
fi

#Recupera listado Canales, buscando "Mount Point"
function Canales ()
{
  echo "${CHANNELS}" | sed -e 's/h3/\'$'\n/g' |  grep 'Mount Point.*<' | awk '{print $NF}' |sed -e 's/<\///g' | grep "flv$" 
}

function AlertSelect()
{
  echo "${TODO}" | grep "${BUSCA}" 
  echo ""
  echo "Es necesario seleccionar UNO"
  exit
}

#################
## PRINCIPAL
################

#Todos los canales
TODO=$(Canales)

#Buscamos si tenemos parametro
SELECT=$(echo "${TODO}" | grep "${BUSCA}")

#Cuantos tenemos encontrados
REGISTROS=$(echo "${SELECT}" | wc -l)

#Hay al menos UNO
SIZE=${#SELECT}


#DEBUG
#echo "B = ${BUSCA}"
#echo "R = ${REGISTROS}"
#echo "SIZE= ${SIZE}"
#exit

#Tenemos mas de un registro
if test ${REGISTROS} -gt 1
then
  AlertSelect
  exit
fi

#No hay canal seleccionado
if test ${#SELECT} -eq 0
then
  AlertSelect
  exit
fi


echo "Seleccionado canal ${SELECT}"

mplayer http://pub7.di.fm/${SELECT}?1 -user-agent "AudioAddict-di/3.2.0.3240 Android/5.1"

exit

