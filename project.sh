#! /bin/bash

#script to add a user to Linux system

function add_user(){
if [ $(id -u) -eq 0 ]; then

        echo "________________________________________________________________"
        echo "                                                                "
        echo "****************Crate New User Account***********************"
        echo "________________________________________________________________"
        echo "                                                                "
        
        read -p "Enter username : " username
        read -s -p "Enter password : " password
        egrep "^$username" /etc/passwd >/dev/null
        if [ $? -eq 0 ]; then
                echo "$username exists!"
                break
        else
                pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
                useradd -m -p $pass $username
                [ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
        fi
else
        echo "Only root may add a user to the system"
        break
fi
}

#script to display all user account
function display_user(){
echo "___________________________________________________________________________________________"
echo "********************************Display All User Account**********************************"
awk -F":" '
BEGIN { 
print "__________________________________________________________________________________________"
printf " %-7s %-15s %-15s %-15s %-15s %-20s\n" ,"No.","User", "UID","GID","Home","Shell" 
print "__________________________________________________________________________________________"
}
'

awk -F":" '
{ printf "%-15s %-15s %-15s %-15s %-20s\n", $1,$3,$4,$6,$7 } ' /etc/passwd | nl     
}

#script to display group account
function display_group(){
    echo "___________________________________________________________________________________________"
    echo "********************************Display All Group Account**********************************"
    awk -F":" '
    BEGIN { 
    print "__________________________________________________________________________________________"
    printf " %-7s %-20s %-15s\n" ,"No.","Group Name", "GroupID" 
    print "__________________________________________________________________________________________"
    }
    '
    awk -F":" '{ printf "%-20s %-15s\n", $1,$3 } ' /etc/group | nl
}


#script to change password user
function change_password(){
        ROOT_UID=0
        E_WRONG_USER=65
        E_NO_SUCH_USER=70
        SUCCESS=0
        echo "________________________________________________________________"
        echo "                                                                "
        echo "****************Change Password User Account********************"
        echo "________________________________________________________________"
        echo "                                                                "

        if [ "$UID" -ne "$ROOT_UID" ]
        then
         echo "You need to be logged in as root to perform this operation"
         #exit $E_WRONG_USER
         break
        else
         echo "Continue with password change"
        fi
        read -p "Enter Username you to change password :" username
        read -p "Enter New Password :" newpassword
        grep -q "$username" /etc/passwd
        if [ $? -ne $SUCCESS ]
        then
          echo "No such user exist"
          #exit $E_NO_SUCH_USER
          break
    fi
    echo "$newpassword" | passwd --stdin "$username"
    echo "Password for $username changed"
    break
}

function delete_user(){
    ROOT_UID=0
    E_NO_SUCH_USER=70
    SUCCESS=0

    echo "________________________________________________________________"
    echo "                                                                "
    echo "****************Delete User Account********************"
    echo "________________________________________________________________"
    echo "                                                                "

    if [ "$UID" -ne "$ROOT_UID" ]
    then
    echo "You need to be logged in as root to perform this operation"
    break
    else
    echo "Continue with Delete user"
    fi

    read -p "Enter Username you to Delete :" username
    grep -q "$username" /etc/passwd
    if [ $? -ne $SUCCESS ]
    then
    echo "No such user exist"
    break
    fi
    userdel $username
    echo "User Deleted"
    break
}


#function create new Group
function create_group(){

    echo "________________________________________________________________"
    echo "                                                                "
    echo "****************Create New Group Account************************"
    echo "________________________________________________________________"
    echo "                                                                "
        
    echo -n "Enter new group name: "
    read group
    if egrep "^$group" /etc/group; then
        #cut -d: -f1 /etc/group
        echo "!!Group $group already exists!!"
        echo -n "Enter different group name: "
        read  name
        groupadd $name
        echo "Group $name was created."
    else
        groupadd $group
        echo "Group $group was crated."
    fi
}

#function Delete group
function delete_group(){
    ROOT_UID=0
    E_WRONG_USER=65
    E_NO_SUCH_USER=70
    SUCCESS=0

    echo "________________________________________________________________"
    echo "                                                                "
    echo "****************Delete Group Account****************************"
    echo "________________________________________________________________"
    echo "                                                                "


    if [ "$UID" -ne "$ROOT_UID" ]
    then
        echo "You need to be logged in as root to perform this operation"
        break
    else
        echo "Continue with Delete group"
    fi
        read -p "Enter groupname you to Delete :" username
        grep -q "$username" /etc/group
    if [ $? -ne $SUCCESS ]
    then
        echo "No such group exist"
        break
    fi
        groupdel $username
        echo "Group Deleted"
        break
}

function addnewuser_group(){
    SUCCESS=0
    echo "________________________________________________________________"
    echo "                                                                "
    echo "****************Add new User to Group Account*******************"
    echo "________________________________________________________________"
    echo "                                                                "
    echo -n "Enter new group name: "
    read group
    echo -n "Enter Username:"
    read username
    if egrep "^$group" /etc/group; then
        #cut -d: -f1 /etc/group
        echo "Group exist..."
        grep -q "$username" /etc/passwd
        if [ $? -ne $SUCCESS ]
            then
            useradd -g $group $username
            echo "$username was added to group $group."
            echo -n "Please setup password for $user:"
            passwd $username
            echo "Password for $username changed"
        else
            echo "User existed"
        fi 

    else 
        echo "Group doesn't exist"

    fi
}
function addexistuser_group(){
     SUCCESS=0  
    echo "________________________________________________________________"
    echo "                                                                "
    echo "*************Add Existing User to Group Account*****************"
    echo "________________________________________________________________"
    echo "                                                                "

    echo -n "Enter new group name: "
    read group
    echo -n "Enter Username:"
    read username
    if egrep "^$group" /etc/group; then
        #cut -d: -f1 /etc/group
        echo "Group exist..."
        grep -q "$username" /etc/passwd
        if [ $? -ne $SUCCESS ]
            then
            echo "User doesn't exist"
            
        else
            echo "User existed"
            usermod -a -G $group $username
            echo "$username was added to group $group."
        fi 

    else 
        echo "Group doesn't exist"

    fi
}


function displayuser_ingroup(){
    echo -n "Enter Group name you want to diplay:"
    read group
    grep "^$group" /etc/group
}

function header(){
        echo "_______________________________________________________"
        echo "|                                                     |"
        echo "|                                                     |"
        echo "|        <--- Account and Group Management --->       |"
        echo "|                                                     |"
        echo "| SLS Year4                                   Group3  |"
        echo "|_____________________________________________________|"
        echo "                                                      "
}
function footer(){

        echo "                                                      "
        echo ",_____________________________________________________,"
        echo "|                                                     |"
        echo "|    ====> Enter any number for select option         |"
        echo "|_____________________________________________________|"
}


while true
do 
    clear
        echo "_______________________________________________________"
        echo "|                                                     |"
        echo "|                                                     |"
        echo "|        <--- Account and Group Management --->       |"
        echo "|                                                     |"
        echo "| SLS Year4                                   Group3  |"
        echo "|_____________________________________________________|"
        echo "                                                      "
        echo "        1. User Account"
        echo "        2. Group Account"
        echo "        3. Modify User/Group Account"
        echo "        4. Display All User/Group Account"
        echo "                                                      "
        echo ",_____________________________________________________,"
        echo "|    ====> Enter any number for select option         |"
        echo "|    ====> Enter Q to Quit Program                    |"
        echo "|                                                     |"
        echo "|_____________________________________________________|"
                read -p "     ====> Please Enter Your Choice :" answer
        case "$answer" in
                1)      while true
                        do
                                clear
                                #invoke header
                                header

                                echo "      1. Display all User Account"
                                echo "      2. Create New User Account"
                                echo "      3. Change password"
                                echo "      4. Delete User Account"
                                echo "      5. Back"
                                #invoke footer
                                footer
                                echo -e "\n"
                                read -p "   ====> Please Enter Your Choice :" answer1
                                case "$answer1" in
                                        1) clear
                                           #invoke display_user
                                           display_user
                                           ;;
                                        2) clear
                                            #invoke function add_user
                                           add_user
                                           ;;
                                        3) clear
                                            #invoke function change-password
                                            change_password
                                            ;;
                                        4) clear 
                                            delete_user
                                            ;;
                                        5) clear
                                           echo "Backing..."
                                           break       
                                esac
                                echo -e "Press enter to continue:"
                                read input
                        clear
                        done
                        ;;
                2)      while true
                        do
                                clear
                                header
                                echo "     1. Create new Group Account"
                                echo "     2. Display Group Account"
                                echo "     3. Delete Group Account"
                                echo "     4. Add new User to Group Account"
                                echo "     5. Add exist User to Group Account"
                                echo "     6. Back"
                                footer
                                echo -e "\n"
                                read -p "    ====> Please Enter Your Choice :" answer1
                                case "$answer1" in
                                        1) clear
                                           create_group
                                           ;;
                                        2) clear
                                           display_group
                                           ;;
                                        3) clear
                                           delete_group
                                           ;;

                                        4) clear 
                                            addnewuser_group
                                            ;;
                                        5) clear
                                            addexistuser_group
                                            ;;
                                        6) clear
                                           echo "Backing..."
                                           break       
                                esac
                                echo -e "Press enter to continue:"
                                read input
                        clear
                        done
                        ;;
                3)      while true
                        do
                                clear
                                header
                                echo "    1. Modify User Password"
                                echo "    2. Back"
                                footer
                                echo -e "\n"
                                read -p "    ====> Please Enter Your Choice :" answer1
                                case "$answer1" in
                                        1) clear
                                           change_password
                                           ;;
                                        2) clear
                                           echo "Backing..."
                                           break       
                                esac
                                echo -e "Press enter to continue:"
                                read input
                        clear
                        done
                        ;;
                4)
                        while true
                        do
                                clear
                                header
                                echo "     1. Display User Account"
                                echo "     2. Display Group Account"
                                echo "     3. Back"
                                footer
                                echo -e "\n"
                                read -p "    ====> Please Enter Your Choice :" answer1
                                case "$answer1" in
                                        1) clear
                                           #invoke display user
                                           display_user
                                           ;;
                                        2) clear
                                           display_group
                                           ;;
                                        3) clear
                                           echo "Backing..."
                                           break
                                           
                                esac
                                echo -e "Press enter to continue:"
                                read input
                        clear
                        done
                        ;;
                q)      clear
                        echo "Exiting . . ."
                        sleep 2
                        exit ;;
                esac
                echo -e "Press Enter to continue :"
                read input
        clear
done

