****************************
Asterisk testing environment
****************************

* To run:
docker-compose up -d

* Then execute the script
sh containers-cp-conf.sh

* Testing softphone
You can register a Sofphone over the asterisk-pstn container with the following credentials:

username: 01177660050
secret: 098098
IP: 172.46.0.3

* Depending on the digit at the end of the dialed number, the pstn-emulator should do the following actions over a call:

0 = busy
1 = Atiende
2 = Marca al softphone
3 = Atiende
4 = Atiende
5 = No answer
6 = Atiende
7 = Atiende
8 = Atiende
9 = Congestion
