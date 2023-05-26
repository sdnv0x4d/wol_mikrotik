#!/usr/bin/env bash

ip_main="10.0.0.1" # IP микротика, с которого будем запускать WoL
COLOR0="echo -e \\033[1;32m" # Green color
COLOR1="echo -e \\033[0;39m" # Standart color
username=" " # SSH user
mac_list=(vlan1-FF:FF:FF:FF:FF:01 \
          vlan2-FF:FF:FF:FF:FF:02 \
          vlan3-FF:FF:FF:FF:FF:03)

for data in ${mac_list[*]} # Получаем все значения из массива mac_list 
  do
    wol_cmd=($(echo ${data} | tr "-" " ")) # Убираем разделитель "-" у каждого значения
    cmd="/tool wol interface=${wol_cmd[0]} mac=${wol_cmd[1]}" # wakeOnLAN команда, которая будет запускаться на Микротике
    ${COLOR0}
      echo "start wol to ${wol_cmd[1]} on ${wol_cmd[0]} interface"
    ${COLOR1}
    ssh ${username}@$ip_main -o "StrictHostKeyChecking no" -p 22 "${cmd}" # SSH-подключение и выполнение команды
  done
