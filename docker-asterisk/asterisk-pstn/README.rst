****************************
Entorno de pruebas asterisk
****************************

* Para levantar el entorno se debe ejecutar:
docker-compose up -d

* Luego ejecutar el bash script
sh containers-cp-conf.sh

* Sofphone de pruebas
Se puede registra un Sofphone sobre el contenedor asterisk-pstn
username: 01177660050
secret: 098098
IP: 172.46.0.3

* Dependiendo de la terminación del numero marcado, pstn-emulator va a realizar las siiguientes acciones sobre una llamada:

Terminación 0 = busy
Terminación 1 = Atiende
Terminación 2 = Marca al softphone
Terminación 3 = Atiende
Terminación 4 = Atiende
Terminación 5 = No answer
Terminación 6 = Atiende
Terminación 7 = Atiende
Terminación 8 = Atiende
Terminación 9 = Congestion
