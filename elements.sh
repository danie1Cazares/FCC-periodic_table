#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  else
   ATOMIC_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE (symbol='$1' OR name='$1')")
  fi

  if [[ -z $ATOMIC_NUM ]]
  then
    echo -e "I could not find that element in the database."
  else

  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUM")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUM")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUM")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUM")
  MPOINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUM")
  BPOINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUM")
  echo -e "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MPOINT celsius and a boiling point of $BPOINT celsius." 
  fi

fi

