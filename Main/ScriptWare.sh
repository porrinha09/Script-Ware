#!/bin/bash

AZUL_CEU="\033[38;2;116;166;253m"
AZUL_FOFO="\033[38;2;128;163;255m"
VERDE="\033[38;2;98;216;137m"
VERDE2="\033[38;2;0;255;0m"
AZUL="\033[38;2;92;92;255m"
BLUE="\033[38;2;128;163;255m"
VERMELHO="\033[38;2;255;0;0m" 
LARANJA="\033[38;2;241;133;30m"
RESET='\033[0m'

function show_commands() {
  echo -e "${AZUL_CEU}Bem-vindo ao jjsploit${RESET}"
  echo -e "${AZUL_CEU}---------------------------------------------${RESET}
${LARANJA}IP:${AZUL_CEU}
{1} - ;my ip
{2} - ;ip info
{3} - ;my mac
{4} - ;all my mac
{5} - ;location

${LARANJA}SCAN:${AZUL_CEU}
{1} - ;port scan

${LARANJA}SITE:${AZUL_CEU}
{1} - ;ip site
{2} - ;port site
{3} - ;erros site
{4} - ;url find
{5} - ;url contar
{6} - ;tamanho site
{7} - ;domain

${LARANJA}DISCORD:${AZUL_CEU}
{1} - ;info user
{2} - ;get token

${LARANJA}COLOR:${AZUL_CEU}
{1} - ;color hex

${LARANJA}FILES:${AZUL_CEU}
{1} - ;find file
{2} - ;view txt
{3} - ;lines file
  
${LARANJA}CONFIGS:${AZUL_CEU}
{99} - ;clear
{200} - ;reset
{100} - ;exit
---------------------------------------------"
}

clear
show_commands

function input() {
echo -n -e "${AZUL_CEU}┌──(Foster)-[~]\n└─$ ${RESET}"
read -r input
}

while true; do
  input

  if [ "$input" == ";my ip" ]; then
    ip=$(curl -s https://ipinfo.io/ip)
    echo "Seu IP: $ip"
  elif [ "$input" == ";ip info" ]; then
    read -p "IP: " ip
    response=$(curl -s https://ipinfo.io/$ip)
    country=$(echo "$response" | grep -o '"country": "[^"]*' | cut -d'"' -f4)
    state=$(echo "$response" | grep -o '"region": "[^"]*' | cut -d'"' -f4)
    city=$(echo "$response" | grep -o '"city": "[^"]*' | cut -d'"' -f4)
    timezone=$(echo "$response" | grep -o '"timezone": "[^"]*' | cut -d'"' -f4)
    postal=$(echo "$response" | grep -o '"postal": "[^"]*' | cut -d'"' -f4)
    current_time=$(TZ=$timezone date +"%H:%M")

    echo "País: $country"
    echo "Estado: $state"
    echo "Cidade: $city"
    echo "Código Postal: $postal"
    echo "Horário: $current_time"
  elif [ "$input" == ";my mac" ]; then
    echo "Seu MAC: $(ip link show | awk '/ether/ {print $2; exit}')"
  elif [ "$input" == ";all my mac" ]; then
    echo "Seus MAC: $(ip link show | awk '/ether/ {print $2}')"
  elif [ "$input" == ";ip site" ]; then
    echo "Digite o URL do site:"
    read url
    ip=$(host $url | awk '/has address/ { print $4 }')
    echo "O IP do site $url é: $ip"
  elif [ "$input" == ";port site" ]; then
    echo "Digite o URL do site:"
    read url
    port=$(nc -z -v -w 1 $url 80 2>&1 | grep -oP '(?<=open\s)\d+')
    echo "A porta do site $url é: $port"
  elif [ "$input" == ";erros site" ]; then
    echo "Digite o URL do site:"
    read url
    num_errors=$(curl -s -o /dev/null -w "%{http_code}" $url | grep -cP '[^2-3]..')
    echo "Número de erros no site $url: $num_errors"

    if [ $num_errors -gt 0 ]; then
      echo "Códigos de erro encontrados:"
      curl -s -o /dev/null -w "%{http_code}\n" $url | grep -vP '^2|^3'
    fi      
  elif [ "$input" == ";url find" ]; then
    echo -e "${LARANJA} Digite o URL da página: ${RESET}"
    read url
    lynx -dump -listonly "$url" | awk '/http/ {print $2}'
  elif [ "$input" == ";contar url" ]; then
    echo -e "${LARANJA} Digite o URL da página: ${RESET}"
    read url
    count=$(lynx -dump -listonly "$url" | grep -c "http")
    echo -e "${LARANJA} o número de links na página é:${RESET} $count"
  elif [ "$input" == ";tamanho site" ]; then
    echo -e "${LARANJA} Digite o URL da página: ${RESET}"
    read url
    tamanho=$(curl -s "$url" | wc -c)
    echo -e "${LARANJA} o tamanho do conteúdo da página e ${RESET}$tamanho${LARANJA} bytes"
  elif [ "$input" == ";domain" ]; then
    echo -e "${BLUE}Digite a URL do site:${RESET}"
    read url
    domain=$(echo "$url" | sed 's|http[s]*://||; s|www\.||; s|/.*||')
    echo "Nome de domínio: $domain"
  elif [ "$input" == ";find file" ]; then
    echo -e "${LARANJA} Digite uma palavra que um arquivo tem: ${RESET}"
    read padrao
    echo -e "${VERDE}Arquivos com '$padrao': ${RESET}"
    echo "---------------------------------------------"
    find /storage/emulated/0 -type f -iname "*$padrao*" -exec basename {} \;
  elif [ "$input" == ";view txt" ]; then
    echo -e "${LARANJA}Digite o nome do arquivo:${RESET}"
    read nome_arquivo
    caminho_download="$EXTERNAL_STORAGE/Download"
    arquivo=$(find "$caminho_download" -type f -name "$nome_arquivo")

    if [ -e "$arquivo" ]; then
      cat "$arquivo"
    else
      echo -e "${VERMELHO}O arquivo não existe${RESET}"
    fi
  elif [ "$input" == ";lines file" ]; then
    echo "Digite o nome do arquivo:"
    read nome_arquivo
    dir_downloads="/sdcard/Download"
    arquivo_encontrado=$(find "$dir_downloads" -name "$nome_arquivo" -type f 2>/dev/null)

    if [ -n "$arquivo_encontrado" ]; then
      linhas=$(wc -l < "$arquivo_encontrado")
      echo "O arquivo $nome_arquivo tem $linhas linhas"
    else
      echo "O arquivo $nome_arquivo não foi encontrado na pasta de downloads."
    fi
    elif [ "$input" == ";location" ]; then
function location {
    show_ip=true
    show_city=true
    show_region=true
    show_country=true
    city_message="Cidade: "
    region_message="Região: "
    country_message="País: "
    ip_message="Endereço IP: "
    
    while getopts "c:r:p:i:m:n:o:" opt; do
        case $opt in
            c) show_city=$OPTARG ;;
            r) show_region=$OPTARG ;;
            p) show_country=$OPTARG ;;
            i) show_ip=$OPTARG ;;
            m) city_message=$OPTARG ;;
            n) region_message=$OPTARG ;;
            o) country_message=$OPTARG ;;
        esac
    done

    data=$(curl -s ipinfo.io/json)

    if [[ $show_ip == true ]]; then
        echo -n "$ip_message"
        echo $data | jq -r '.ip'
    fi
    if [[ $show_city == true ]]; then
        echo -n "$city_message"
        echo $data | jq -r '.city'
    fi
    if [[ $show_region == true ]]; then
        echo -n "$region_message"
        echo $data | jq -r '.region'
    fi
    if [[ $show_country == true ]]; then
        echo -n "$country_message"
        echo $data | jq -r '.country'
    fi
}

location
elif [ "$input" == ";port scan" ]; then
echo -n "Enter the IP address to scan: "
read target_ip

echo "Scanning ports on $target_ip"

for port in {1..65535}; do
    nc -zvw1 $target_ip $port &>/dev/null && echo "Port $port is open"
done

echo "Port scan completed."
  elif [ "$input" == ";info user" ]; then
read -p "Eter the Discord user ID: " user_id


response=$(curl -s -H "Authorization: Bot $bot_token" \
                   "https://discord.com/api/v10/users/$user_id")

if echo "$response" | grep -q "code"; then
  echo "Error"
else
  id=$(echo "$response" | jq -r '.id')
  username=$(echo "$response" | jq -r '.username')
  avatar=$(echo "$response" | jq -r '.avatar')
  discriminator=$(echo "$response" | jq -r '.discriminator')
  public_flags=$(echo "$response" | jq -r '.public_flags')
  flags=$(echo "$response" | jq -r '.flags')
  banner=$(echo "$response" | jq -r '.banner')
  accent_color=$(echo "$response" | jq -r '.accent_color')
  global_name=$(echo "$response" | jq -r '.global_name')
  avatar_decoration_data=$(echo "$response" | jq -r '.avatar_decoration_data')
  banner_color=$(echo "$response" | jq -r '.banner_color')
  clan=$(echo "$response" | jq -r '.clan')

  echo "User Information:"
  echo "ID: $id"
  echo "Username: $username"
  echo "Avatar: $avatar"
  echo "Discriminator: $discriminator"
  echo "Public Flags: $public_flags"
  echo "Flags: $flags"
  echo "Banner: $banner"
  echo "Accent Color: $accent_color"
  echo "Global Name: $global_name"
  echo "Avatar Decoration Data: $avatar_decoration_data"
  echo "Banner Color: $banner_color"
  echo "Clan: $clan"
fi
  elif [ "$input" == ";get token" ]; then
read -p "Digite seu e-mail do Gmail: " email
read -s -p "Digite sua senha do Gmail: " password
echo

response=$(curl -s -X POST -H "Content-Type: application/json" -d '{"email": "'"${email}"'", "password": "'"${password}"'"}' https://discord.com/api/v9/auth/login)

error=$(echo "${response}" | jq -r '.message')
if [ "$error" != "null" ]; then
    echo "Erro ao fazer login: ${error}"
    exit 1
fi

token=$(echo "${response}" | jq -r '.token')

echo -e "${AZUL_CEU}Token:${RESET} ${token}"
  elif [ "$input" == ";color hex" ]; then
echo "Digite o código da cor hex:"
read cor_hex

r=$(printf "%d" 0x${cor_hex:0:2})
g=$(printf "%d" 0x${cor_hex:2:2})
b=$(printf "%d" 0x${cor_hex:4:2})

COR="\033[38;2;${r};${g};${b}m"

echo "$COR"

echo -e "${COR}Exemplo${COR}\033[0m"
  elif [ "$input" == ";reset" ]; then
    clear
    sleep 1
    show_commands
  elif [ "$input" == ";clear" ]; then
    clear
  elif [ "$input" == ";exit" ]; then
    clear
    break
  fi
done