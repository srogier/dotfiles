#!/bin/bash

bulk=false
zip=false
innodb=false

#récupération des options
while getopts zbi option
do
	case $option in
		b)
			bulk=true
			;;
		z)
			zip=true;
			;;
		i) 	
			innodb=true;
			;;
	esac;
done;

shift $(($OPTIND - 1))

#controle des arguments
case $# in
	2)
		folder=`pwd`
	;;
	3)
		folder=$3
	;;
	*)
		echo "--usage $0 [-bzi] database table [dossier destination]";
		exit 1;
	;;
esac




#génération du dump
cmd="mysqldump --complete-insert --no-create-info --skip-add-drop-table -uroot "
if [ $bulk = false ]
then
	#ecriture bulk
	cmd="$cmd  --skip-extended-insert "
fi

if [ $innodb = true ]
then
	#pour le cas de fixtures innodb
	cmd="$cmd --single-transaction " 
fi


#gestion du db_name table_name
#ex: mysqldump [--options] database table
cmd="$cmd $1 $2"

#format du nom du fichier : /rep/table.sql
sqlFile="$folder/$2.sql"

$cmd > $sqlFile

#en cas d'export, saut de ligne auto pour que ca soit plus lisible
if [ $bulk = true ]
then
	sed -e "s/),(/),\n(/g" -i $sqlFile
fi 

#gzipage du fichier dump
if [ $zip = true ]
then 
	gzip $sqlFile
	sqlFile="$sqlFile.gz"
fi

echo "Fichier sql généré : $sqlFile"
