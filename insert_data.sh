#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

($PSQL "TRUNCATE TABLE games, teams")
# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != 'year' ]]
then
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  if [[ -z $WINNER_ID && -z $OPPONENT_ID ]]
  then
    RESULT_ADD_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    RESULT_ADD_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
  elif [[ -z $WINNER_ID ]]
  then
    RESULT_ADD_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
  elif [[ -z $OPPONENT_ID ]]
  then
    RESULT_ADD_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
  fi

  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  
  RESULT_ADD_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")

fi
done
