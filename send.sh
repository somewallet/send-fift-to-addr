#!/usr/bin/env bash

# Скачать бинарники (пребилды) fift и func можно тут: https://github.com/ton-blockchain/ton/actions?query=branch%3Amaster+is%3Acompleted

<<comment

# Пути к бинарникам func и fift (Для Ubuntu). 
path_to_func_binaries=./ton-binaries-ubuntu/func # func
path_to_fift_binaries=./ton-binaries-ubuntu/fift # fift
path_to_lite_client_binaries=./ton-binaries-ubuntu/lite-client # lite-client

comment

# Пути к бинарникам func и fift (Комп Севы). 
path_to_func_binaries=/Users/vsevolodignatev/Desktop/Projects/ton-macos-binaries/crypto/func # func
path_to_fift_binaries=/Users/vsevolodignatev/Desktop/Projects/ton-macos-binaries/crypto/fift # fift
path_to_lite_client_binaries=/Users/vsevolodignatev/Desktop/Projects/ton-macos-binaries/lite-client/lite-client # lite-client

# Аргументы
path_to_msg_body=$1 # Адрес fift-файла, который нужно отправить
path_to_dest_addr=$2 # Адрес, на который нужно отправить

# Библиотеки
fift_libs=./lib/fift-libs # Стандартные библиотеки FIFT
fift_cli=./lib/cli.fif # Библиотека CLI

# Конфиги
mainnet_config=./config/global.config.json # mainnet
testnet_config=./config/testnet-global.config.json # testnet

$path_to_fift_binaries -I $fift_libs -L $fift_cli -s ./create_external_message.fif $path_to_msg_body $path_to_dest_addr

for i in {1..30}
do
    echo "Attempt #$i"
    $path_to_lite_client_binaries -v 3 --timeout 3 -C $testnet_config -v 2 -c 'sendfile ./build/boc/external_message.boc'
    echo "$?"
    if [ $? == "0" ];
    then
        echo "Success in attempt #$i"
        break
    fi
done

exit $?