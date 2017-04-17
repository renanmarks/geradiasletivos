#!/bin/bash

# Script para gerar um CSV contendo os dias letivos do semestre.
#
# Sintaxe:
# ./geradiasletivos.sh <data de inicio do semestre> <data de fim do semestre> <dias da semana que haverao aulas>
# <data de inicio do semestre> = formato dd/mm/aaaa
# <data de fim do semestre>    = formato dd/mm/aaaa
# <dias da semana que haverao aulas> = sequencia de codigos:
#     0 = segunda
#     1 = terca
#     2 = quarta
#     3 = quinta
#     4 = sexta
#     5 = sabado

export ZZFERIADO="13/06:SantoAntonio 26/08:CampoGrande 11/10:DivisaoEstado"

dataInicio=$1
dataFinal=$2

fzz="./funcoeszz-15.5.sh"

quantidadeDiasEntreDatas=`$fzz zzdata $2 - $1`
quantidadeSemanas=`expr $quantidadeDiasEntreDatas / 7`

contadorAulas=0
diasDaSemana=()

for diaParametro in `seq 3 $#`;
do
    diasDaSemana+=(${!diaParametro})
done

echo "Semana;Aula;Data;Dia;"

for semana in `seq 0 $quantidadeSemanas`;
do
    for dia in "${diasDaSemana[@]}";
    do
        diaLetivo=`$fzz zzdata 17/04/2017 + $(($semana * 7 + $dia))`
        nomeDia="(`$fzz zzdiadasemana $diaLetivo`)"
        feriado="(`$fzz zzferiado $diaLetivo`)"
        
        if [[ $feriado == *"Não"* ]]; then
            feriado=""
            contadorAulas=$(($contadorAulas+1))
            echo "$(($semana + 1));$contadorAulas;$diaLetivo;$nomeDia;$feriado"
        fi
    done
done
