#!/bin/bash


pausa(){
        echo " "
        read -n 1 -p "Presiona uma tecla para continuar..."
        }


menu_split(){
    echo "#  1.) Splitar ISO                              #"
    echo "#  0.) Sair                                     #"
    echo "#################################################"

    read -n 1 -p "    Tecle 1 para iniciar " s
    case $s in
    1) splitter ;;
    0) clear
    exit;;
    *)

    echo " "
    echo "Opcion invalida!"
    ;;
    esac


}

menu_ul_cfg(){
    echo "#  2.) Criar arquivo ul.cfg                     #"
    echo "#  0.) Sair                                     #"
    echo "#################################################"

    read -n 1 -p "    Tecle 2 para criar o arquivo ul.cfg" s
    case $s in
    2) create_cfg ;;
    0) clear
    exit;;
    *)

    echo " "
    echo "Opcion invalida!"
    ;;
    esac


}


menu(){
    echo "#  1.) Splitar ISO                              #"
    echo "#  2.) Criar arquivo ul.cfg                     #"
    echo "#  3.) Alterar nome das partes criadas          #"
    echo "#  0.) Salir                                    #"
    echo "#################################################"

    read -n 1 -p "    Que desea hacer? " s
    case $s in
    1) splitter ;;
    2) create_cfg ;;
    3) alterar_parts;;
    0) clear
    exit
    ;;
    *)

    #El resto
    echo " "
    echo "Opcion invalida!"
    ;;
    esac

    pausa
    menu
}


barra(){
        clear
        pwd
        echo "############ ulPS2 # $1 ############" 
       }

pasta_iso(){
        read -p "Digite a pasta onde está a ISO: " pasta
        u="$USER"
        cd /home/$u/$pasta
}

splitter(){
       Iso=$(ls *.iso)
       echo
       #reaInforme o caminho da ISO: " iso
       split -d -b 1024m --verbose "$Iso"
       echo "splitagem da iso concluida. execute a opcao 2"

}



get_id() {
    # Obtém o nome da ISO (pega apenas a primeira ISO encontrada)
    nome=$(ls *.iso 2>/dev/null | head -n 1)

    # Verifica se encontrou uma ISO
    if [ -z "$nome" ]; then
        echo "Nenhuma ISO encontrada no diretório."
        return 1
    fi

    # Cria ponto de montagem se não existir
    ponto_montagem="/media/$USER"


    # Monta a ISO
    echo
    sudo mount -o loop "$nome" "$ponto_montagem"

    # Busca o ID do jogo dentro da ISO
    caminho=$(find "$ponto_montagem" -type f \( -name "SLPM*" -o -name "SCUS*" -o -name "SCES*" -o -name "SLES*" -o -name "SLUS*" \) | head -n 1)

    # Verifica se encontrou um arquivo válido
    if [ -z "$caminho" ]; then
        echo "Nenhum arquivo de ID encontrado na ISO."
        sudo umount "$ponto_montagem"
        return 1
    fi

    # Retorna apenas o nome do arquivo (ID do jogo)
    id=$(basename "$caminho")
    echo $id
    # Desmonta a ISO após o uso
    sleep 4
    sudo umount "$ponto_montagem"
}





create_cfg(){
    id=$(get_id);
    parts=$(ls x* | wc -l)
    midia=14    #CD=12 DVD=14


    #enquando o nome for maior vai ler (while)...
    read -p "Digite um nome para o jogo: " name
    n=${#name}


    #se o nome for maior que 32
    if [ $n -gt 32 ]; then
        echo "O nome não pode ser maior que 32 caracteres."

    else  #se o nome for menor que 32
        restante=$((32-$n))
        echo "caracteres restantes: $restante"

        printf "$name" > ul.cfg
        for i in $(seq 1 "$restante"); do
           printf '\x00' >> ul.cfg; 
        done

        printf "ul.$id\x00\x$parts\x$midia\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" >> ul.cfg  && tr -d '\n' < ul.cfg > temp.cfg && mv temp.cfg ul.cfg
        echo "arquivo ul.cfg criado com sucesso.  execute a opcao 3"
     fi
}



alterar_parts(){
      # Obtém o nome da ISO (pega apenas a primeira ISO encontrada)
       nome=$(ls *.iso 2>/dev/null | head -n 1)

        # Verifica se encontrou uma ISO
        if [ -z "$nome" ]; then
            echo "Nenhuma ISO encontrada no diretório."
            return 1
        fi

        # Cria ponto de montagem se não existir
        ponto_montagem="/media/$USER"


        # Monta a ISO
        echo
        sudo mount -o loop "$nome" "$ponto_montagem"

        # Busca o ID do jogo dentro da ISO
        caminho=$(find "$ponto_montagem" -type f \( -name "SCUS*" -o -name "SCES*" -o -name "SLES*" -o -name "SLUS*" -o -name "SLPM*" \) | head -n 1)

        # Verifica se encontrou um arquivo válido
        if [ -z "$caminho" ]; then
            echo "Nenhum arquivo de ID encontrado na ISO."
            sudo umount "$ponto_montagem"
            return 1
        fi

        # Retorna apenas o nome do arquivo (ID do jogo)
        patch_base=$(basename "$caminho")
        #id_modificado=$(echo "$patch_base" | cut -d'.' -f1)


        # Desmonta a ISO após o uso
        sleep 4
        sudo umount "$ponto_montagem"

         parts=$(ls x* | wc -l)
         id=$patch_base

         read -p "Digite um nome para o jogo: " name
         crc32=$(./convert "$name")
         for i in $(seq -f "%02g" 0 $parts)
         do
             mv "x$i" ul.$crc32.$id.$i
             echo "x$i"
         done




}




barra

menu
