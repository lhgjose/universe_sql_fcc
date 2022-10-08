#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=postgres --no-align --tuples-only -c"

echo -e "\nEnter your username:"
read USERNAME

GET_USER_INFO_RESULT=$($PSQL "SELECT games_played, best_game FROM user_info WHERE name = '$USERNAME'")

if [[ -z $GET_USER_INFO_RESULT ]]
then
  INSERT_USER_RESULT=$($PSQL "INSERT INTO user_info(name) VALUES('$USERNAME')")
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
else
  GET_GAMES_INFO=$($PSQL "SELECT games_played, best_game FROM user_info WHERE name = '$USERNAME'")
  IFS="|" read GAMES_PLAYED BEST_GAME <<< $GET_USER_INFO_RESULT
  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

RANDOM_NUMBER=$(( $RANDOM % 1000 + 1 ))
echo -e "Guess the secret number between 1 and 1000:"
read NUMBER_GUESS
ATTEMPS=1
NEW_GAMES_PLAYED=$(( $GAMES_PLAYED + 1 ))

while [[ $NUMBER_GUESS -ne $RANDOM_NUMBER ]]
do
  ATTEMPS=$(( $ATTEMPS + 1 ))
  if [[ ! $NUMBER_GUESS =~ ^[0-9]+$ ]]
  then
    echo -e "That is not an integer, guess again:"
    read NUMBER_GUESS
  elif [[ $NUMBER_GUESS -lt $RANDOM_NUMBER ]]
  then
    echo "It's higher than that, guess again:"
    read NUMBER_GUESS
  elif [[ $NUMBER_GUESS -gt $RANDOM_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
    read NUMBER_GUESS
  fi
done

if [[ $ATTEMPS -lt $BEST_GAME || $BEST_GAME -eq 0 ]]
then
  UPDATE_USER_INFO=$($PSQL "UPDATE user_info SET games_played=$NEW_GAMES_PLAYED, best_game=$ATTEMPS WHERE name='$USERNAME'")
else
  UPDATE_USER_INFO=$($PSQL "UPDATE user_info SET games_played=$NEW_GAMES_PLAYED WHERE name='$USERNAME'")
fi

echo -e "\nYou guessed it in $ATTEMPS tries. The secret number was $RANDOM_NUMBER. Nice job!"





#echo $RANDOM_NUMBER
