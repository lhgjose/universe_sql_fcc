#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

RETRIEVE_INFO() {
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    GET_ELEMENT=$($PSQL "SELECT atomic_number,symbol,name FROM elements WHERE atomic_number=$1")
  else
    GET_ELEMENT=$($PSQL "SELECT atomic_number,symbol,name FROM elements WHERE symbol='$1' OR name='$1'")
  fi

  if [[ -n $GET_ELEMENT ]]
  then
    IFS="|" read ATOMIC_NUMBER SYMBOL NAME <<< $GET_ELEMENT
    GET_MORE_INFO=$($PSQL "SELECT type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
    IFS="|" read TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< $GET_MORE_INFO
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  else
    echo "I could not find that element in the database."
  fi
fi
}

RETRIEVE_INFO $1
