#!/bin/sh

#  wget https://raw.githubusercontent.com/BLBMS/Android-Mining/main/pool-verus.sh && chmod +x pool-verus.sh && ./pool-verus.sh

# Kateri je novi POOL
new_file="config-verus.json"

# Prenese datotetko s pool VERUS
cd ~/ccminer/
rm -f pool-verus.sh
rm -f $new_file
wget https://raw.githubusercontent.com/BLBMS/Android-Mining/main/$new_file

pool_name="${new_file#*config-}"
pool_name="${pool_name%.json}"

printf "\n\e[93m■■■ new pool: $pool_name ■■■\e[0m\n"

# Ime datoteke s staro vsebino
file="config.json"

# Iskanje datoteke s končnico .ww
ww_file=$(ls ~/*.ww 2>/dev/null | head -n 1)

if [ -z "$ww_file" ]; then
    echo "\n\e[93m Datoteka .ww ne obstaja."
   
    # Uporaba grep za iskanje ustreznega niza in izpis vsebine
    content=$(grep -o '4wc\..*",' "$file" | sed 's/4wc\.//;s/",//')

    if [ "$content" = "BLB" ] || [ -z "$content" ]; then
        printf "\n\e[93m Obstoječ delavec ne obstaja."
        printf "\nIme delavca: "
        read delavec
    else
        delavec=$(cat "$ww_file")
    fi
fi

echo "\nDelavec je: $delavec \e[0m"

# Zapiši delavca
rm -f ~/*.ww ~/worker
cat << EOF > ~/worker
EOF
echo $delavec >> ~/worker
cat << EOF > ~/$delavec.ww
EOF

# Zapri vse screene
#screen -ls | grep -o '[0-9]\+\.' | awk '{print $1}' | xargs -I {} screen -X -S {} quit

# Iskanje niza "BLB" in zamenjava z $delavec
sed -i "0,/BLB/ s//$delavec/" "$new_file"

#mv -f $new_file $file

# Zažene miner
#~/ccminer/start.sh