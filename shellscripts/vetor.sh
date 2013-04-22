#!/bin/bash

SERVERS=("beta" "mysql-pressflow2" "www10" "www11" "www12" "www13" "mysql1" "mysql2" "teste")
#for ((i=1 ; i<${#SERVERS[@]} ; i++)); do
#echo ${SERVERS[$i]}
#done

				echo -e "
							Folder: /var/www/${SERVERS[0]}/
							Banco: ${SERVERS[1]}
							Backup: ${SERVERS[2]}
							WebS: ${SERVERS[@]:2}
			  "
