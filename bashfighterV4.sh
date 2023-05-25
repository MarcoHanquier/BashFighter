function game() {

# Variables définissant les PV et les dégâts des attaques (et les couleurs pour simplifier les choses)
PV_J1=20
ATTAQUE1_J1=5
ATTAQUE2_J1=3
ATTAQUE3_J1=6
ATTAQUE4_J1=20
POTION_J1=2

PV_J2=20
ATTAQUE1_J2=5
ATTAQUE2_J2=3
ATTAQUE3_J2=6
ATTAQUE4_J2=9
POTION_J2=2

RED=$'\e[0;91m'
BLUE=$'\e[0;94m'
GREEN=$'\e[0;92m'
ORANGE=$'\e[0;93m'
WHITE=$'\e[0;37m'

while [ $PV_J1 -gt 0 ] 
do
combat-j1

if [ "$PV_J2" -gt 0 ] ; then # Si joueur 2 est mort, met fin à la partie
combat-j2
else
break
fi

done # Fin du jeu et publication des scores dans un fichier texte

if [ "$PV_J1" -gt 0 ] ; then
echo "${GREEN}Victoire du Joueur 1${WHITE}"
echo "Victoire du Joueur 1" >> BashFighter/scores.txt
   else
   echo "${GREEN}Victoire du Joueur 2${WHITE}"
echo "Victoire du Joueur 2" >> BashFighter/scores.txt
fi

echo "Rejouer ?"
read ouinon

if [ "$ouinon" = "Oui" ] || [ "$ouinon" = "oui" ] ; then
game

else
echo "A la prochaine !"

fi
}



function combat-j1() {
clear
echo "${GREEN}--- ${BLUE}Joueur 1 : $PV_J1 pv ${GREEN}--- ${BLUE}Joueur 2 : $PV_J2 pv${GREEN}---${WHITE}" #Affichage constant des pv des joueurs
echo "${GREEN}Joueur 1${WHITE}, il vous reste ${RED}$PV_J1 pv${WHITE}, choisissez une action : "
echo "${ORANGE}Attaque"
echo "Potion (reste $POTION_J1)${WHITE}"
echo -n "--> "
read ACTION_J1

# Si le joueur tape Potion, vérifie combien de potions il reste. Si au moins une, le soigne, sinon tant pis pour lui
if [[ "$ACTION_J1" = "Potion" && "$POTION_J1" -gt 0 ]] ; then
PV_J1=$((PV_J1+7))
echo "Le joueur 1 se soigne de ${GREEN}7pv${WHITE} !"
POTION_J1=$((POTION_J1-1))
read

elif [[ "$ACTION_J1" = "Potion" && "$POTION_J1" -le 0 ]] ; then
echo "Vous n'avez plus de potion ! Va falloir attaquer !"
read
combat-j1


elif [ "$ACTION_J1" = "Attaque" ] ; then
attaque-j1 

else
echo "Ce n'est pas une commande !"
read
combat-j1

fi
}

function attaque-j1() {
clear
echo "${GREEN}--- ${BLUE}Joueur 1 : $PV_J1 pv ${GREEN}--- ${BLUE}Joueur 2 : $PV_J2 pv${GREEN}---${WHITE}"
echo "${GREEN}Joueur 1${WHITE}, choisissez une attaque : "
echo "${ORANGE}Uppercut"
echo "Kick"
echo "Hadoken"
echo "Shoryuken${WHITE}"
echo -n "--> "
read CHOIX_J1

case $CHOIX_J1 in
   Uppercut)
   ATTAQUE_J1=$ATTAQUE1_J1 # Fera les dégâts de la variable ATTAQUE1_J1
   attaque-result-j1
      ;;
   Kick)
   ATTAQUE_J1=$ATTAQUE2_J1
   attaque-result-j1
      ;;
   Hadoken)
   ATTAQUE_J1=$ATTAQUE3_J1
   attaque-result-j1
      ;;
   Shoryuken)
   ATTAQUE_J1=$ATTAQUE4_J1
   attaque-result-j1
      ;;
   *)
     echo "Ce n'est pas une attaque! "
     read
     attaque-j1 # On est pas des monstres, si le joueur fait une faute sur son attaque, il peut retenter
     ;;
esac
}

function attaque-result-j1() {
CRITIQUE=$(( $RANDOM % 20 + 1 )) # Génère un nombre de 1 à 20
if [ $CRITIQUE -eq 20 ] ; then # Si ce nombre est 20, coup critique et double les dégâts
PV_J2=$((PV_J2-(ATTAQUE_J1 *2)))
echo "${RED}Le joueur 1 fait un $CHOIX_J1 et c'est un coup critique ! $((ATTAQUE_J1 *2)) dégâts ! ${WHITE}"
read
elif [ $CRITIQUE -eq 1 ] ; then # Si ce nombre est 1, échec critique et ne fait aucun dégâts
PV_J2=$((PV_J2-(ATTAQUE_J1 *0)))
echo "${RED}Le joueur 1 fait un $CHOIX_J1 et c'est un échec critique ! 0 dégâts ! ${WHITE}"
read

else
PV_J2=$((PV_J2-ATTAQUE_J1))
echo "${GREEN}Le joueur 1 fait un $CHOIX_J1 et fait $ATTAQUE_J1 dégâts !${WHITE}"
read
fi
}


function combat-j2() {
clear
echo "${GREEN}--- ${BLUE}Joueur 1 : $PV_J1 pv ${GREEN}--- ${BLUE}Joueur 2 : $PV_J2 pv${GREEN}---${WHITE}"
echo "${GREEN}Joueur 2${WHITE}, il vous reste ${RED}$PV_J2 pv${WHITE}, choisissez une action : "
echo "${ORANGE}Attaque"
echo "Potion (reste $POTION_J2)${WHITE}"
echo -n "--> "
read ACTION_J2

if [[ "$ACTION_J2" = "Potion" && "$POTION_J2" -gt 0 ]] ; then
PV_J2=$((PV_J2+7))
echo "Le joueur 2 se soigne de ${GREEN}7pv${WHITE} !"
POTION_J2=$((POTION_J2-1))
read

elif [[ "$ACTION_J2" = "Potion" && "$POTION_J2" -le 0 ]] ; then
echo "Vous n'avez plus de potion ! Va falloir attaquer !"
read
combat-j2

elif [ "$ACTION_J2" = "Attaque" ] ; then
attaque-j2

else
echo "Ce n'est pas une commande !"
read
combat-j2

fi
}

function attaque-j2() {
clear
echo "${GREEN}--- ${BLUE}Joueur 1 : $PV_J1 pv ${GREEN}--- ${BLUE}Joueur 2 : $PV_J2 pv${GREEN}---${WHITE}"
echo "${GREEN}Joueur 2${WHITE}, choisissez une attaque : "
echo "${ORANGE}Uppercut"
echo "Kick"
echo "Hadoken"
echo "Shoryuken${WHITE}"
echo -n "--> "
read CHOIX_J2

case $CHOIX_J2 in
   Uppercut)
   ATTAQUE_J2=$ATTAQUE1_J1
      attaque-result-j2
      ;;
   Kick)
   ATTAQUE_J2=$ATTAQUE2_J1
      attaque-result-j2
      ;;
   Hadoken)
   ATTAQUE_J2=$ATTAQUE3_J1
      attaque-result-j2
      ;;
   Shoryuken)
   ATTAQUE_J2=$ATTAQUE4_J1
      attaque-result-j2
      ;;
   *)
     echo "Ce n'est pas une attaque! "
     read
     attaque-j2
     ;;
esac
}

function attaque-result-j2() {
CRITIQUE=$(( $RANDOM % 20 + 1 ))
if [ $CRITIQUE -eq 20 ] ; then
PV_J1=$((PV_J1-(ATTAQUE_J2 *2)))
echo "${RED}Le joueur 2 fait un $CHOIX_J2 et c'est un coup critique ! $((ATTAQUE_J2 *2)) dégâts ! ${WHITE}"
read

elif [ $CRITIQUE -eq 1 ] ; then
PV_J1=$((PV_J1-(ATTAQUE_J2 *0)))
echo "${RED}Le joueur 2 fait un $CHOIX_J2 et c'est un échec critique ! 0 dégâts ! ${WHITE}"
read

else
PV_J1=$((PV_J1-ATTAQUE_J2))
echo "${GREEN}Le joueur 2 fait un $CHOIX_J2 et fait $ATTAQUE_J2 dégâts !${WHITE}"
read
fi
}




game










