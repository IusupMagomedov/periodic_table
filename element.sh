#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]] 
then
  echo Please provide an element as an argument.
else
  re='^[0-9]+$'
  ATOMIC_NUMBER=0
  if [[ $1 =~ $re ]]; 
  then
    ATOMIC_NUMBER=$1;
  else
    if  [ ${#1} \> 2 ]
    then
      REQUESTED_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
    else
      REQUESTED_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
    fi
    if [[ -z $REQUESTED_ATOMIC_NUMBER ]]
    then 
      echo I could not find that element in the database.
      exit
    else
      ATOMIC_NUMBER=$REQUESTED_ATOMIC_NUMBER
      # echo ATOMIC_NUMBER value after assignment from REQUESTED_ATOMIC_NUMBER is: $ATOMIC_NUMBER
    fi
  fi
  NAME=$($PSQL "SELECT name FROM elements FULL JOIN properties USING (atomic_number) WHERE atomic_number = '$ATOMIC_NUMBER'")
  SYMBOL=$($PSQL "SELECT symbol FROM elements FULL JOIN properties USING (atomic_number) WHERE atomic_number = '$ATOMIC_NUMBER'")
  TYPE=$($PSQL "SELECT type FROM elements FULL JOIN properties USING (atomic_number) FULL JOIN types USING (type_id) WHERE atomic_number = '$ATOMIC_NUMBER'")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM elements FULL JOIN properties USING (atomic_number) WHERE atomic_number = '$ATOMIC_NUMBER'")
  MELTING_POINT_CELSIUS=$($PSQL "SELECT melting_point_celsius FROM elements FULL JOIN properties USING (atomic_number) WHERE atomic_number = '$ATOMIC_NUMBER'")
  BOILING_POINT_CELSIUS=$($PSQL "SELECT boiling_point_celsius FROM elements FULL JOIN properties USING (atomic_number) WHERE atomic_number = '$ATOMIC_NUMBER'")
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
fi
