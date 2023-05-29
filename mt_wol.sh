#!/usr/bin/env bash

ip_mt=" " # IP микротика, с которого будем запускать WoL
COLOR0="echo -e \\033[1;32m" # Green color
COLOR1="echo -e \\033[0;39m" # Standart color
username=" " # SSH user
mac_list=(vlan1-FF:FF:FF:FF:FF:01 \
          vlan2-FF:FF:FF:FF:FF:02 \
          vlan3-FF:FF:FF:FF:FF:03)
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

${COLOR0}
  echo "start Wake On LAN"
${COLOR1}
ssh ${username}@$ip_mt -o "StrictHostKeyChecking no" -p 22 "${cmd_array[*]}" &>/dev/null # SSH-подключение и выполнение команд из массива cmd_array без вывода в stdout