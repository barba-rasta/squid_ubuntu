
spin () {
local pid=$!
local delay=0.25
local spinner=( '█■■■■' '■█■■■' '■■█■■' '■■■█■' '■■■■█' )
while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
for i in "${spinner[@]}"
do
tput civis
echo -ne "[34m [*] \e[37m DESCARGANDO \e[31m[[32m$i[31m][0m   ";
sleep $delay
printf "";
done
done
printf "   "
tput cnorm
printf "[1;31m[[1;33mINSTALADO[1;31m]\e[0m"
echo "";
}
pkg install nginx &> /dev/null & spin
