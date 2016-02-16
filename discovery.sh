#! /bin/bash


#/etc/hosts
if [[ -f /etc/hosts ]] && [[ -r /etc/hosts ]]
then
#	egrep  "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" /etc/hosts | grep -v "#" | awk -F " " '{for (x=2; x<=3; x++) printf("%s\n", $x);}' | egrep "^[A-Za-z]" | egrep "[A-Za-z0-9]$"
	cat /etc/hosts | grep -v "#" | awk -F " " '{ for(x=2;x<=NF;x++) printf("%s\n", $x)}' | egrep -v "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" 
fi


if [[ -f /etc/ssh/ssh_config ]] && [[ -r /etc/ssh/ssh_config ]]
then
	grep -w "Host" /etc/ssh/ssh_config  | egrep -v "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | grep -v "#" |  awk -F " " '{print $2}'
	grep -w "HostName" /etc/ssh/ssh_config | egrep -v "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | grep -v "#"  | awk -F " " '{print $2}'
fi

#get users
if [[ -f /etc/passwd ]] && [[ -r /etc/passwd ]]
then
	 awk -F ":" '{print $6}' /etc/passwd | while read l
	do
		fileName=$l/.ssh/config
		if [[ -f $fileName ]] && [[ -r $fileName ]]
		then
			grep -iw "Host" $fileName | egrep -v "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | grep -v "#"  | awk -F " " '{print $2}'
			grep -iw "HostName" $fileName | egrep -v "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | grep -v "#"  | awk -F " " '{print $2}'

			grep -iw "Host" $fileName | grep -v "#" | awk -F " " '{for (x=2; x<=NF; x++) printf("%s\n", $x);}' | egrep -v "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"
			grep -iw "HostName" $fileName | grep -v "#" | awk -F " " '{for (x=2; x<=NF; x++) printf("%s\n", $x);}' | egrep -v "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"

		fi

		fileName=$l/.ssh/authorized_keys
		if [[ -f $fileName ]] && [[ -r $fileName ]]
        	then
			pattern=`cat $fileName | egrep -o 'from=".*"' | awk -F '"' '{print $2}'`
			for i in $(echo $pattern | sed "s/,/ /g")
			do
				if  [[ ! $i =~ "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" ]]
				then
					echo $i
				fi
			done
		
			pattern=`cat .ssh/authorized_keys |  egrep -o 'permitopen=".*"' | awk -F '"' '{print $2}'`
			for i in $(echo $pattern | sed "s/,/ /g")
    	            	do
        	                echo $i | sed 's/permitopen=//g'| sed 's/"//g'
        	        done

			cat $fileName |  egrep -o 'permitopen=".*"' | awk -F "," '{ for(x=1;x<=NF;x++) printf("%s\n", $x)}' | awk -F '"' '{print $2}' | awk -F ":" '{print $1}' | egrep -v "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"

			grep "@" $fileName | grep -v "#" | awk -F "@" '{print $2}'
		fi

		fileName=$l/.ssh/known_hosts
		if [[ -f $fileName ]] && [[ -r $fileName ]]
        	then
			cat $fileName | awk -F' ' '{ if($1 ~ "^@.*") printf "%s\n", $2; else printf "%s\n",$1}' | awk -F',' '{for(i=1; i<=NF; i++) printf "%s\n", $i}' | cut -d ":" -f1 | tr -d '[]' | egrep -v "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"
		fi

	done
fi


if [[ -f /etc/ssh/ssh_known_hosts ]] && [[ -r /etc/ssh/ssh_known_hosts ]]
then
	cat /etc/ssh/ssh_known_hosts | awk -F' ' '{ if($1 ~ "^@.*") printf "%s\n", $2; else printf "%s\n",$1}' | awk -F',' '{for(i=1; i<=NF; i++) printf "%s\n", $i}' | cut -d ':' -f1 | tr -d '[]' | egrep -v "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"
fi

