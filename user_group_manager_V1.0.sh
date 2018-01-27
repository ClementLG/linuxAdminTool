#!/bin/bash

##############################################################
#                                                            #
#      				 LE GRUIEC Clément                       #
#       Script to simplify the user and group management     #
#                  contact me on legruiec.fr                 #
#                                                            #
##############################################################

echo -e "--- User and group Manager, by LE GRUIEC Clément --- \n\n"
echo -e "you have to install whois: sudo apt install whois, and have the privilieges !"

echo -e -n "-To create a new user enter 1 \n-To create a new group enter 2 \n-To add or remove an existing user in an existing group enter 3 \n-To delete an user enter 4 \n-To delete a group enter 5\n-To show user and/or group enter 6\nEnter the action you want to do: "
read choice

if [ $choice = 1 ]
	then
	 	echo -e "\n --Create a new user--\n"
	 	echo -e -n "Username: "
	 	read username
	 	if id -u $username &>/dev/null
			then
	 			echo "The user already existing !"
	 		else
	 			echo -n "Do you want to change the default home directory, default is /home/ (Y/N): "
	 			read choice
	 			if [ $choice = Y ]
				then
				 	echo -n "Enter the home directory (absolute path): "
				 	read homeDirecory
				 	if cd $homeDirecory &>/dev/null
						then
 							echo "Path existing, ok..."
 						else
 							echo "Path doen't exist !"
					fi
			 	elif [ $choice = N ]
			 		then
			 			homeDirecory="/home"
			 	else echo "ERROR, wrong choice entered"
				fi
				echo -n "Do you want add the user in an existing group ? (Y/N): "
				read choice
				if [ $choice = Y ]
				then
				 	echo -n "Enter the name of the group: "
				 	read group
					arg_g="-g $group"
				 	if more /etc/group | grep "$group:" &>/dev/null
						then
 							echo "Group existing, ok..."
 						else
 							echo -n "group doen't exist ! Do you want to create them ? (Y/N)"
 							read choice
 							if [ $choice = Y ]
							then
							 	sudo groupadd $group
						 	elif [ $choice = N ]
						 		then
						 			echo "no group created"
						 	else echo "ERROR, wrong choice entered"
							fi
					fi
			 	elif [ $choice = N ]
			 		then
						arg_g=""
			 			echo "The user will not have a group"
			 	else echo "ERROR, wrong choice entered"
				fi
				echo -n "Do you want to change the interpreter, default is /bin/bash (Y/N): "
	 			read choice
	 			if [ $choice = Y ]
				then
				 	echo -n "Enter the new interpreter: "
				 	read interpreter
				 	if tail -1 $interpreter &>/dev/null
						then
 							echo "interpreter existing, ok..."
 						else
 							echo "interpreter doen't exist !"
					fi
			 	elif [ $choice = N ]
			 		then
						interpreter="/bin/bash"
			 			echo "The user will have the default interpreter"
			 	else echo "ERROR, wrong choice entered"
				fi
				echo -n "Enter the password: "
				read password
				#creation:
				sudo useradd -mb $homeDirecory -p  `mkpasswd $password` -s $interpreter $arg_g $username
				echo "A new user is born !"

		fi

elif [ $choice = 2 ]
	then
 	echo -e "\n --Create a new group-- \n"
 	echo -e -n "Name of the new group: "
	 	read group
	 	if more /etc/group | grep "$group:" &>/dev/null
			then
				echo "$group is already exist !"
			else
				sudo groupadd $group
				echo "group created !"
		fi


elif [ $choice = 3 ]
	then
 	echo -e "\n --Add or remove  an existing user of an existing group--\n"
 	echo -e -n "Add an existing user in an existing group, enter 1\nRemove an existing user in an existing group, enter 2\nYour choice: "
 	read choice
 	if [ $choice = 1 ]
 		then
 			echo -e -n "Username: "
	 		read username
	 		echo -e -n "Group: "
	 		read group
	 		if (id -u $username &>/dev/null) && (more /etc/group | grep "$group:" &>/dev/null)
	 			then
	 				sudo gpasswd -a "$username" "$group"
	 			else echo "You entered a wrong user or group"
	 		fi


 	elif [ $choice = 2 ]
 		then
 			echo -e -n "Username: "
	 		read username
	 		echo -e -n "Group: "
	 		read group
	 		if (id -u $username &>/dev/null) && (more /etc/group | grep "$group:" &>/dev/null)
	 			then
	 				sudo gpasswd -d "$username" "$group"
	 			else echo "You entered a wrong user or group"
	 		fi
 	else echo "You entered a wrong choice"
 	fi


elif [ $choice = 4 ]
	then
 	echo "\n --Delete an user-- \n"
	echo -e -n "user you want to delete: "
	 	read username
	 	if id -u $username &>/dev/null
			then
	 			echo -n "Do you want to delete his home directory also ? (Y/N): "
				read choice
				if [ $choice = Y ]
					then
						sudo userdel -r $username &>/dev/null
						echo "User and his repository deleted"
					elif [ $choice = N ]
					then
						sudo userdel  $username &>/dev/null
						echo "User and his repository deleted"
					else echo "ERROR, wrong choice entered"
				fi
			else echo "User doen't exist !"
		fi


elif [ $choice = 5 ]
	then
 	echo -e "\n --Delete a group-- \n"
 	echo -e -n "group you want to delete: "
	read group
	if more /etc/group | grep "$group:" &>/dev/null
		then
			sudo groupdel $group
			echo "$group deleted."
		else
			echo "$group doen't exist !"
	fi

elif [ $choice = 6 ]
	then
 	echo -e "\n --Show the group and/or User-- \n"
 	echo -e -n "show groups and users, enter 1\nshow only the users, enter 2\nshow only the groups, enter 3\nYour choice: "
	read choice
	if [ $choice = 1 ]
		then
		echo -e "\nuser <=> group\n"
		for i in `more /etc/passwd | cut -d ':' -f 1-3` ;
		do
			user=`echo $i | cut -d ':' -f -1`
			idgroup=`echo $i | cut -d ':' -f 3-`
			group=`grep $idgroup  /etc/group | cut -d ':' -f -1`
			echo "$user <=> $group"
		done

 	elif [ $choice = 2 ]
 		then
 			cat /etc/passwd | awk -F: '{print "user= " $1 " id=" $3}'
 	elif [ $choice = 3 ]
 		then
 			cat /etc/group | awk -F: '{print "groupe= " $1 " id=" $3}'
 	else echo "You entered a wrong choice"

 	fi

else echo "You entered a wrong choice"

fi


##############################################################
#                                                            #
#      				 LE GRUIEC Clément                       #
#       Script to simplify the user and group management     #
#                  contact me on legruiec.fr                 #
#                                                            #
##############################################################