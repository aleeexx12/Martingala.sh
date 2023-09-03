#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


function ctrl_c(){
	echo -e "\n\n${redColour}[+]Saliendo...${endColour}"
	exit 1
}

trap ctrl_c INT


function helpPanel(){
echo -e "\n${yellowColour}Manual de uso:${endColour}"
	echo -e "\t${blueColour}-h -->${endColour}${grayColour}Panel de ayuda${endColour}"
	echo -e "\t${blueColour}-m -->${endColour}${purpleColour}Introducir cantidad de dinero disponible${endColour}"
	echo -e "\t${blueColour}-t -->${endColour}${purpleColour}Introducir la técnica a usar (Martingala)${endColour}"
	exit 1
}

function martingala() {
    contador_jugadas=0
    echo -e "\n${yellowColour}[+] Dinero actual: ${greenColour}$money€${endColour} ${endColour}"
    echo -ne "${yellowColour}[+] Dinero a apostar: ${endColour}" && read initial_bet
    echo -ne "${yellowColour}[+] A que deseas apostar continuamente  (par o impar): ${endColour}" && read par_o_impar

    echo -e "${purpleColour}[+] Vamos a jugar a ${greenColour}$initial_bet€${endColour} a ${greenColour}$par_o_impar${endColour}${endColour}\n\n"

    while true; do
        money=$(($money - $initial_bet))
        echo -e "\nJugada número: ${turquoiseColour}$((contador_jugadas += 1))${endColour} --> Acabas de apostar ${greenColour}$initial_bet€${endColour} y tienes ${greenColour}$money€${endColour}"
        numero_random="$(($RANDOM % 37))"
        echo -e "\n${yellowColour}[+] Ha salido el número ${blueColour}$numero_random${endColour}${endColour}"

        if [ ! "$money" -le 0 ]; then
            if [ "$par_o_impar" == "par" ]; then
                if [ "$(($numero_random % 2 ))" -eq 0 ]; then
                    if [ "$numero_random" -eq 0 ]; then
                        echo "[+] Perdida, el 0 no se considera número par."
                        reward=$(($initial_bet * 2))
                    else
                        echo -e "[+] Ha salido número par, ganas"
                        reward=$(($initial_bet * 2))
                        money=$(($money + $reward))
                        echo -e "${turquoiseColour}[+] Ahora tienes ${greenColour}$money${endColour}${endColour}\n\n"
                    fi
                else
                    echo -e "[+] El numero que ha salido es impar, pierdes"
                    initial_bet=$(($initial_bet*2))
                    echo -e "${turquoiseColour}[+] Ahora tienes ${greenColour}$money${endColour}${endColour}\n\n"
                fi
                sleep 2.6

			else
				if [ "$(($numero_random % 2 ))" -eq 1 ]; then
					if [ "$numero_random" -eq 0 ]; then
						echo "[+] Perdida, el 0 no se considera número par."
                        reward=$(($initial_bet * 2))
                    else
                    	echo -e "[+] Ha salido número impar, ganas"
                        reward=$(($initial_bet * 2))
                        money=$(($money + $reward))
                        echo -e "${turquoiseColour}[+] Ahora tienes ${greenColour}$money${endColour}${endColour}\n\n"
					fi
				else
					if [ $numero_random -eq 0 ]; then
						echo "[+] Perdida, el 0 no se considera número par."
                        reward=$(($initial_bet * 2))
                    else
				 	    echo -e "[+] El numero que ha salido es par, pierdes"
                        initial_bet=$(($initial_bet*2))
                        echo -e "${turquoiseColour}[+] Ahora tienes ${greenColour}$money${endColour}${endColour}\n\n"
					fi 
                fi
                sleep 2.6
            fi
        else
            echo -e "\n${redColour}No hay más dinero disponible!!!${endColour}"
            exit 0
        fi
    done
}

while getopts "m:t:h" argumento; do
   case $argumento in
		m) money=$OPTARG;;
		t) tecnica=$OPTARG;;
		h) helpPanel;;
   esac
done

if [ $money ] && [ $tecnica ]; then
	if [ "$tecnica" == "Martingala" ]; then
		martingala
	else
		echo -e "\n${redColour}[!] La técnica introducida no existe${endColour}"
		helpPanel
	fi
else
	helpPanel
fi
