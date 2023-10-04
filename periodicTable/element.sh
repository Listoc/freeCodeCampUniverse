# !/bin/bash
PSQL="psql -U freecodecamp --dbname=periodic_table -t -c"
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  #Get info
  ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, types.type FROM elements AS e JOIN properties AS p USING(atomic_number) JOIN types USING(type_id) WHERE e.name='$1'")
  
  if [[ -z $ELEMENT_INFO ]]
  then
    ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, types.type FROM elements AS e JOIN properties AS p USING(atomic_number) JOIN types USING(type_id) WHERE e.symbol='$1'")
    
    if [[ -z $ELEMENT_INFO && "$1" =~ ^[0-9]+$ ]]
    then
      ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, types.type FROM elements AS e JOIN properties AS p USING(atomic_number) JOIN types USING(type_id) WHERE e.atomic_number=$1")
    fi
  
  fi
  #Output result
  if [[ ! -z $ELEMENT_INFO ]]
  then
    echo "$ELEMENT_INFO" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  else
    echo "I could not find that element in the database."
  fi
fi
