#!/bin/sh

PGUSER=postgres
PGPASSWORD= 

export PGUSER PGPASSWORD

LOGFILE=/opt/backup/scripts/backup.log
PG_DUMP="/usr/pgsql-9.1/bin/pg_dump"  # tu podajemy pelena sciezke do

PG_DUMP_OPTS="-h localhost -p 5432 -U ${PGUSER} -w ${PASSWORD} -F c --column-inserts"

#TIMESTAMP=`date +%Y%m%d%H%M%S`
TIMESTAMP=`date +%Y%m%d%H%M`

# 1 zmienna z  linni komend
BACKUP_ROOT="$1"
# 2 zmienna  z linni komend
DB_NAME="$2"

#  wjazd od katalogu
        cd "${BACKUP_ROOT}"
        DB_BACKUP="${DB_NAME}-${TIMESTAMP}.backup"
#  budujemy plik
        DB_ARCHIVE="${DB_BACKUP}.tar.gz"
        ${PG_DUMP} ${PG_DUMP_OPTS} -f "${DB_BACKUP}" "${DB_NAME}"
#  laczymy sie z baza

#  jesli brak np hasla - koniec
            while test $? != 0
                do
                #echo "Brak Hasla"
              echo " LIPA -" `date "+%F_%H:%M:%S:"` "Backup bazy '${DB_NAME}' niepowiodla sie!!" >> $LOGFILE
                    rm "${DB_BACKUP}"
                exit 1;
            done

if [ ! -r "${DB_BACKUP}" ];
        then
                logger "File '${DB_BACKUP}' not found"
        else
                tar -czf "${DB_ARCHIVE}" "${DB_BACKUP}"
                  echo "GIT -" `date "+%F_%H:%M:%S:"` "Backup bazy '${DB_NAME}' powiodl sie." >> $LOGFILE
                   rm "${DB_BACKUP}"
        fi


#kasujemy  starsze pliki niz 7 dni 

find /sciezka/backup/ -type f -name "nazwa_bakupu*" -atime  +7 -print0 | xargs -0 -r rm

