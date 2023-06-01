# wol_mikrotik

Рассылает Wake-on-LAN пакеты по хостам между различными VLAN c Mikrotik-устройства.

## How-to
```bash
Syntax: ./mt_wol.sh [-f file|-i|-h]
options:
f     Select vlan-mac list from external file
i     Select vlan-mac list from internal array in script
h     Help
```

## Требования

 - Установка соединения с Mikrotik по SSH-ключу
 - Наличие доступа Mikrotik к необходимым VLAN
 - Указать переменную `username`
 - Описать переменную `mac_list`, разделителем является "-"
 - Или создать список vlan-mac в отдельном файле, пример файла - `mac_list.example`

## Пояснение
`mt_wol.sh` - отсылает Wake-On-LAN magic-пакеты по разным VLAN на ПК, попарно указанные VLAN-интерфейсы с MAC-адресами в двумерном массиве или в отдельном файле. Команды с MAC и VLAN складываются в отдельный массив, затем поднимается SSH-сессия и запускаются команды из массива. Подключение осуществляется через SSH по 22 порту.
