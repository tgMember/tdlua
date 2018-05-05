#!/bin/bash
logo() {
    declare -A logo
    seconds="0.003"
logo[0]="  __           __  ___               __            "
logo[1]=" / /_  ___ _  /  |/  / ___   __ _   / /  ___   ____"
logo[2]="/ __/ / _ '/ / /|_/ / / -_) /  ' \ / _ \/ -_) / __/"
logo[3]="\__/  \_, / /_/  /_/  \__/ /_/_/_//_.__/\__/ /_/   "
logo[4]="     /___/                                         "
logo[5]="                                                   "    
logo[6]="      @tgMember        ******      @sajjad_021     "
printf "\e[1;33m\t"
    for i in ${!logo[@]}; do
        for x in `seq 0 ${#logo[$i]}`; do
            printf "${logo[$i]:$x:1}"
            sleep $seconds
        done
        printf "\n\t"
    done
printf "\n"
}

lualibs=(
'luasec'
'redis-lua'
'fakeredis'
'serpent'
'dkjson'
'--server=http://luarocks.org/dev openssl'
)

pkg=(
'c++'
'clang3.4'
'gcc4.9'
'msvc19.0'
'zlib'
'doxygen'
'libconfig'
'git'
'build-essential'
'cmake'
'libssl-dev'
'liblua5.2-dev'
'gperf'
'libconfig++-dev'
'autoconf'
'libjansson-dev'
'libpython-dev'
'libnotify-dev'
'wget'
'screen'
'tmux'
'make'
'unzip'
'luarocks'
'libjansson4'
'libstdc++6'
'libconfig9'
'gcc-4.9'
'g++-4.9'
)

make_progress() {
exe=`lua <<-EOF
    print(tonumber($1)/tonumber($2)*100)
EOF
`
    echo ${exe:0:4}
}

download_libs_lua() {
    local i
    for ((i=0;i<${#lualibs[@]};i++)); do
        printf "\r\33[2K"
        printf "\rtgMember: wait... [`make_progress $(($i+1)) ${#lualibs[@]}`%%] [$(($i+1))/${#lualibs[@]}] ${lualibs[$i]}"
        sudo luarocks install ${lualibs[$i]} &>> .logluarocks.txt
    done
    sleep 0.2
    cd ..; rm -rf luarocks-2.2.2*
}

configure() {
    dir=$PWD
     wget http://luarocks.org/releases/luarocks-2.2.2.tar.gz &>> .install.log
      tar zxpf luarocks-2.2.2.tar.gz &>> .install.log
      cd luarocks-2.2.2
      ./configure &>> .install.log
	    make bootstrap &>> .install.log
    if [[ ${1} != "--no-download" ]]; then
        download_libs_lua
       rm -rf luarocks*
    fi
}


installation() {
	for i in $(seq 1 100); do
	    sleep 0.7
    		if [ $i -eq 100 ]; then
        		echo -e "XXX\n100\nDone!\nXXX"
    		   elif [ $(($i % 3)) -eq 0 ]; then
			  let "phase = $i / 3"
        		  echo -e "XXX\n$i\n${pkg[phase]}\nXXX"
			 sudo apt-get install -y ${pkg[$phase]} &>> .install.log
		    else
        		echo $i
    		fi 
done | whiptail --title 'TeleGram Advertising bot Install and Configuration' --gauge "${pkg[0]}" 6 60 0
}


apt-get -y update

apt-get -y upgrade

apt-get install -y libreadline-dev libconfig-dev libssl-dev liblua5.2-dev lua-socket lua-sec lua-expat git libevent-dev lua-socket lua5.2 liblua5.2 redis-server software-properties-common g++ libconfig++-dev lua-lgi libreadline5 expat libexpat1-dev whiptail

apt-get -y update

apt-get -y upgrade

add-apt-repository -y ppa:ubuntu-toolchain-r/test

apt-get -y update

clear

logo

echo -e "\033[0;00m\n"

installation

update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.9 &>> .install.log

apt-get autoclean &>> .install.log

echo -e "\n\033[1;31mplease waite ... .. .\nThis operation may take a few minutes\n"

apt-get -y update &>> .install.log
apt-get -y dist-upgrade &>> .install.log
apt-get -y autoremove &>> .install.log

printf "\n\e[38;5;213m\t"

configure

git clone --recursive https://github.com/tdlib/td.git

cd td
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ../
make -j6
make install
cd ../../

echo -e "\033[0;00m\n"

git clone --recursive https://github.com/Tencent/rapidjson.git
cd rapidjson

mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ../
make test
make install

cd ../../

for ((i=0;i<101;i++)); do
printf "\rConfiguring... [%i%%]" $i
sleep 0.009
done

echo -e "\n\033[1;32mInstall Complete\033[0;00m\n"
service redis-server restart &>> .install.log

rm -rf README.md