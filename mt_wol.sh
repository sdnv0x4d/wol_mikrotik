#!/usr/bin/env bash

ip_mt=" " # IP Mikrotik, с которого будем запускать WoL
COLOR0="echo -e \\033[1;32m" # Green color
COLOR1="echo -e \\033[0;39m" # Standart color
username=" " # SSH user

help_list(){  # Help
  echo "mt_wol.sh send wake-on-lan magic-packets to hosts across different VLANs"
  echo
  echo "Syntax: ./mt_wol.sh [-f file|-i|-h]"
  echo "options:"
  echo "f     Select vlan-mac list from external file"
  echo "i     Select vlan-mac list from internal array in script"
  echo "h     Help"
}

int_wol(){  # internal mac_list
  mac_list=(vlan1-FF:FF:FF:FF:FF:01 \
            vlan2-FF:FF:FF:FF:FF:02 \
            vlan3-FF:FF:FF:FF:FF:03)
}

ext_wol(){  # external mac_list
  mac_list="$(cat $OPTARG)"
}

ssh_cmd(){  # Подключение к Mikrtoik и выполнение wol
  ${COLOR0}
    echo "start Wake On LAN"
  ${COLOR1}
  ssh ${username}@$ip_mt -o "StrictHostKeyChecking no" -p 22 "${cmd_array[*]}" &>/dev/null # SSH-подключение и выполнение команд из массива cmd_array без вывода в stdout
}

main(){
  declare -a cmd_array=() # Объявление индексированного массива

  for data in ${mac_list[*]} # Получаем все значения из массива mac_list 
    do
      wol_cmd=($(echo ${data} | tr "-" " ")) # Убираем разделитель "-" у каждого значения
      cmd="/tool wol interface=${wol_cmd[0]} mac=${wol_cmd[1]}; " # wakeOnLAN команда, которая будет запускаться на Микротике
      ${COLOR0}
        echo "add cmd of ${wol_cmd[1]} on ${wol_cmd[0]} interface to cmd_array"
      ${COLOR1}
      cmd_array+=($cmd) # Добавление команды в массив всех команд
    done
  ssh_cmd
}


# Args check
if [ "$*" == "" ]; then
    >&2 help_list
    exit 0
fi

# Menu
while getopts "f:ih" option; do
   case $option in
      f) # external mac_list
         ext_wol
         main
         exit;;
      i) # internal mac_list
         int_wol
         main
         exit;;
      h) # help list
         help_list
         exit;;
     \?) # incorrect option
         echo "Error: Invalid option"
         exit;;
   esac
done
