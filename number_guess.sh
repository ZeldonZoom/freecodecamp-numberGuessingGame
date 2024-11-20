#!/bin/bash

PSQL="psql --username=postgres --dbname=number_guess -t --no-align -c"

COUNT=0
RANDOM_NUMBER=$(( ($RANDOM % 1000) + 1 ))
echo $RANDOM_NUMBER

echo Enter your username:
read USERNAME

GET_USER=$($PSQL "select user_id from users where username='$USERNAME';")
if [[ -z $GET_USER ]]
then
  echo Welcome, $USERNAME! It looks like this is your first time here.
else
  GET_BEST_GUESS=$($PSQL "select guess from games where user_id=$GET_USER order by guess limit 1;")
  echo Welcome back, $GET_USER! You have played games, and your best game took $GET_BEST_GUESS guesses.
fi

while true
do
  echo Guess the secret number between 1 and 1000:
  read INPUT

  if ! [[ $INPUT =~ ^-?[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
  else
    
  fi
done