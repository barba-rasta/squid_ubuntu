#!/bin/bash
#BY JORGE BARBA
i="[Instalado]"
spin () {

local pid=$!
local delay=0.25
local spinner=( '█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█' )

while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do

for i in "${spinner[@]}"
do
	tput civis
	echo -ne "\033[31m\r[\e[0;50;32m~\033[31m] \e[0;50;36m DESCARGANDO .....\e[33m\033[31m[\033[33m$i\033[31m]\033[0m   ";
	sleep $delay
	printf "\b\b\b\b\b\b\b\b";
done
done
printf "   \b\b\b\b\b"
tput cnorm
printf "\e[0;50;91m [\e[0;50;36mInstalado\e[0;50;91m]${FORT}";
echo "";

}
declare -A cor=( [0]="\033[1;37m" [1]="\033[1;31m" [2]="\033[1;32m" [6]="\033[1;36m" [4]="\033[1;31m" )
#LISTA PORTAS
mportas () {
unset portas
portas_var=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN")
while read port; do
var1=$(echo $port | awk '{print $1}') && var2=$(echo $port | awk '{print $9}' | awk -F ":" '{print $2}')
[[ "$(echo -e $portas|grep "$var1 $var2")" ]] || portas+="$var1 $var2\n"
done <<< "$portas_var"
i=1
echo -e "$portas"
}
fun_ip () {
MEU_IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
MEU_IP2=$(wget -qO- ipv4.icanhazip.com)
[[ "$MEU_IP" != "$MEU_IP2" ]] && IP="$MEU_IP2" || IP="$MEU_IP"
}

msg_bar (){
echo -e "\e[1;34m▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬\e[0m"
}
msg_bra='echo -e "\033[1;33m'
#BY JORGE BARBA

fun_bar () {
comando[0]="$1"
comando[1]="$2"
 (
[[ -e $HOME/fim ]] && rm $HOME/fim
${comando[0]} -y > /dev/null 2>&1
${comando[1]} -y > /dev/null 2>&1
touch $HOME/fim
 ) > /dev/null 2>&1 &
echo -ne "\033[1;32m ["
while true; do
   for((i=0; i<13; i++)); do
   echo -ne "\033[1;39m■■"
   sleep 0.1s
   done
   [[ -e $HOME/fim ]] && rm $HOME/fim && break
   echo -e "\033[1;32m]"
   sleep 1s
   tput cuu1
   tput dl1
   echo -ne "\033[1;32m ["
done
echo -e "\033[1;32m]\033[1;33m -\033[1;36m 100%\e[0m"
}

#BY JORGE BARBA
#ETHOOL SSH
fun_eth () {
eth=$(ifconfig | grep -v inet6 | grep -v lo | grep -v 127.0.0.1 | grep "encap:Ethernet" | awk '{print $1}')
    [[ $eth != "" ]] && {
    msg -bar
    echo -e "${cor[3]} Aplicar el sistema para mejorar los paquetes SSH?"
    echo -e "${cor[3]} Opciones para usuarios avanzados"
    msg -bar
    read -p "[S/N]: " -e -i n sshsn
    tput cuu1 && tput dl1
           [[ "$sshsn" = @(s|S|y|Y) ]] && {
           echo -e "${cor[1]} Correccion de problemas de paquetes en SSH..."
 	   msg -bar
           echo -e " Cual es la tasa RX"
           echo -ne "[ 1 - 999999999 ]: "; read rx
           [[ "$rx" = "" ]] && rx="999999999"
           echo -e "Cual es la tasa TX"
           echo -ne "[ 1 - 999999999 ]: "; read tx
           [[ "$tx" = "" ]] && tx="999999999"
           apt-get install ethtool -y > /dev/null 2>&1
           ethtool -G $eth rx $rx tx $tx > /dev/null 2>&1
           msg -bar
           }
     }
}






#BY JORGE BARBA
#Instalador squid soporte a nuevos O.S 
fun_squid  () {
if [[ -e /etc/squid/squid.conf ]]; then
var_squid="/etc/squid/squid.conf"
elif [[ -e /etc/squid3/squid.conf ]]; then
var_squid="/etc/squid3/squid.conf"
fi
[[ -e $var_squid ]] && {
echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m DESISTALANDO SQUID"
msg_bar
fun_bar 'apt remove squid' 'apt purge squid'
fun_bar 'apt purge squid3' 'apt autorremove'
rm -rf /etc/squid squid3
msg_bar
echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m Proceso Terminado"
msg_bar
[[ -e $var_squid ]] && rm $var_squid
return 0
}
msg_bar
echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURACIÓN  AUTOMÁTICA SQUID"
msg_bar
echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m UBUNTU 18-19-20-22-24"
sleep 2s
msg_bar
echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m DETECTANDO SU SISTEMA "
sleep 3s
msg_bar


#BY JORGE BARBA
if cat /etc/os-release | grep PRETTY_NAME | grep "Ubuntu 24.04"; then
    tput cuu1 && tput dl1
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m UBUNTU 24.04"
    msg_bar
    wget -qO - https://packages.diladele.com/diladele_pub.asc | sudo apt-key add -  > /dev/null 2>&1
    echo "deb https://squid71.diladele.com/ubuntu/ noble main" \
        > /etc/apt/sources.list.d/squid71.diladele.com.list
    apt-get update -y  &> /dev/null & spin
    apt install -y squid-common  squid-openssl  libecap3 libecap3-dev   &> /dev/null & spin
    msg_bar
    echo -ne "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m REINICIANDO SERVICOS"
    systemctl enable squid  > /dev/null 2>&1
    service squid restar  > /dev/null 2>&1
    echo -e " \033[1;31m [\033[1;32mOK\033[1;31m]"
    msg_bar
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURADO CON EXITO"
    msg_bar
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m Enter Para Continuar" && read enter
    source menu



#BY JORGE BARBA
elif cat /etc/os-release | grep PRETTY_NAME | grep "Ubuntu 22.04"; then
    tput cuu1 && tput dl1
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m UBUNTU 22.04"
    msg_bar
    wget -qO - https://packages.diladele.com/diladele_pub.asc | sudo apt-key add -  >/dev/null 2>&1

    echo "deb https://squid613.diladele.com/ubuntu/ jammy main" \
        > /etc/apt/sources.list.d/squid613.diladele.com.list

    apt-get update &> /dev/null & spin
    apt-get install -y  squid-openssl squidclient  libecap3 libecap3-dev &> /dev/null & spin
    msg_bar
    echo -ne "\033[1;31m[\033[1;32m!\033[1;31m]\033[1;33m REINICIANDO SERVICOS"
    systemctl enable squid  > /dev/null 2>&1
    service squid restar  > /dev/null 2>&1
    echo -e " \033[1;31m[\033[1;32mOK\033[1;31m]"
    msg_bar
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURADO CON EXITO"
    msg_bar
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m Enter Para Continuar" && read enter
    source menu




#BY JORGE BARBA
elif cat /etc/os-release | grep PRETTY_NAME | grep "Ubuntu 20.04"; then
    tput cuu1 && tput dl1
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m UBUNTU 20.04"
    msg_bar
    apt update  &> /dev/null & spin
    apt -y install apache2-utils squid  &> /dev/null & spin
    touch /etc/squid/passwd
    rm -f /etc/squid/squid.conf
    touch /etc/squid/blacklist.acl
    wget -q --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/serverok/squid-proxy-installer/master/squid.conf  >/dev/null 2>&1
    echo -ne "\033[1;31m[\033[1;32m!\033[1;31m]\033[1;33m REINICIANDO SERVICOS"
    systemctl enable squid  > /dev/null 2>&1
    service squid restar  > /dev/null 2>&1
    echo -e " \033[1;31m[\033[1;32mOK\033[1;31m]"
    msg_bar
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURADO CON EXITO"
    msg_bar
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m Enter Para Continuar" && read enter
    source menu

#BY JORGE BARBA
elif cat /etc/os-release | grep PRETTY_NAME | grep "Ubuntu 19.04"; then
    tput cuu1 && tput dl1
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m Ubuntu 19.04"
    msg_bar
    apt update &> /dev/null & spin
    apt -y install apache2-utils squid &> /dev/null & spin
    touch /etc/squid/passwd
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    wget --no-check-certificate -O /etc/squid/squid.conf https://www.dropbox.com/s/5mb69eainxialac/squid.conf  >/dev/null 2>&1
    echo -e "acl url1 dstdomain -i $ip" >> /etc/squid/squid.conf 
    /sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
    /sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    echo -ne "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m REINICIANDO SERVICOS"
    systemctl enable squid  > /dev/null 2>&1
    service squid restar  > /dev/null 2>&1
    echo -e " \033[1;31m [\033[1;32mOK\033[1;31m]"
    msg_bar
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURADO CON EXITO"
    msg_bar
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33mEnter Para Continuar" && read enter
    source menu

#BY JORGE BARBA
elif cat /etc/os-release | grep PRETTY_NAME | grep "Ubuntu 18.04"; then
    tput cuu1 && tput dl1
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m UBUNTU 18.04"
    msg_bar
    apt update &> /dev/null & spin
    apt -y install apache2-utils squid &> /dev/null & spin
    touch /etc/squid/passwd
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    wget --no-check-certificate -O /etc/squid/squid.conf https://www.dropbox.com/s/5mb69eainxialac/squid.conf  >/dev/null 2>&1
    /sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
    /sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    echo -ne "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m REINICIANDO SERVICOS"
    systemctl enable squid  > /dev/null 2>&1
    service squid restar  > /dev/null 2>&1
    msg_bar
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURADO CON EXITO"
    msg_bar
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33mEnter Para Continuar" && read enter
    source menu



else
    msg_bar
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m SISTEMA NO SOPORTADO"
    exit 1;
fi
#/usr/bin/htpasswd -b -c /etc/squid/passwd USERNAME_HERE PASSWORD_HERE
}
#BY JORGE BARBA
online_squid () {
payload="/etc/payloads"
echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m SQUID CONFIGURADO"
msg_bar
echo -e "${cor[1]}[${cor[2]}01${cor[1]}]⇨${cor[6]} COLOCAR HOST EN SQUID"
echo -e "${cor[1]}[${cor[2]}02${cor[1]}]⇨${cor[6]} REMOVER HOST DE SQUID"
echo -e "${cor[1]}[${cor[2]}03${cor[1]}]⇨${cor[6]} DESINSTALAR SQUID"
echo -e "${cor[1]}[${cor[2]}00${cor[1]}]⇨${cor[6]} SALIR"
msg_bar
while [[ $varpay != @(0|[1-3]) ]]; do
read -p "[0/3]: " varpay
tput cuu1 && tput dl1
done
if [[ "$varpay" = "0" ]]; then
return 1
elif [[ "$varpay" = "1" ]]; then
echo -e "${cor[4]} Hosts Actuales Dentro del Squid"
msg_bar
cat $payload | awk -F "/" '{print $1,$2,$3,$4}'
msg_bar
while [[ $hos != \.* ]]; do
echo -ne "${cor[4]} Escriba el nuevo host: " && read hos
tput cuu1 && tput dl1
[[ $hos = \.* ]] && continue
echo -e "${cor[4]} Comience con .${cor[0]}"
sleep 2s
tput cuu1 && tput dl1
done
host="$hos/"
[[ -z $host ]] && return 1
[[ `grep -c "^$host" $payload` -eq 1 ]] &&:echo -e "${cor[4]}$(fun_trans  "Host ya Exciste")${cor[0]}" && return 1
echo "$host" >> $payload && grep -v "^$" $payload > /tmp/a && mv /tmp/a $payload
echo -e "${cor[4]} Host Agregado con Exito"
msg_bar
cat $payload | awk -F "/" '{print $1,$2,$3,$4}'
msg_bar
if [[ ! -f "/etc/init.d/squid" ]]; then
service squid3 reload
service squid3 restart
else
/etc/init.d/squid reload
service squid restart
fi	
return 0
elif [[ "$varpay" = "2" ]]; then
echo -e "${cor[4]} Hosts Actuales Dentro del Squid"
msg_bar
cat $payload | awk -F "/" '{print $1,$2,$3,$4}'
msg_bar
while [[ $hos != \.* ]]; do
echo -ne "${cor[4]} Digite un Host: " && read hos
tput cuu1 && tput dl1
[[ $hos = \.* ]] && continue
echo -e "Comience con ."
sleep 2s
tput cuu1 && tput dl1
done
host="$hos/"
[[ -z $host ]] && return 1
[[ `grep -c "^$host" $payload` -ne 1 ]] &&!echo -e "${cor[5]}Host No Encontrado" && return 1
grep -v "^$host" $payload > /tmp/a && mv /tmp/a $payload
echo -e "${cor[4]}Host Removido Con Exito"
msg_bar
cat $payload | awk -F "/" '{print $1,$2,$3,$4}'
msg -bar
if [[ ! -f "/etc/init.d/squid" ]]; then
service squid3 reload
service squid3 restart
else
/etc/init.d/squid reload
service squid restart
fi	
return 0
elif [[ "$varpay" = "3" ]]; then
fun_squid
fi
}
if [[ -e /etc/squid/squid.conf ]]; then
online_squid
elif [[ -e /etc/squid3/squid.conf ]]; then
online_squid
else
fun_squid
fi
#BY JORGE BARBA
