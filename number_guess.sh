#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=table -t --no-align -c"

COUNT=0
RANDOM_NUMBER=$(( ($RANDOM % 1000) + 1 ))
echo $RANDOM_NUMBER

echo Enter your username:
read USERNAME

$GET_USER=$($PSQL "select * from users where username='$USERNAME'")
if [[ -z $GET_USER ]]
then
  echo Welcome, $USERNAME! It looks like this is your first time here.
else
  echo Welcome back, $GET_USER! You have played games, and your best game took <number of guesses> guesses.
fi

while true
do
  echo Guess the secret number between 1 and 1000:
  read INPUT

  if ! [[ $INPUT =~ ^-?[0-9]+$ ]]; then
    echo "That is not an integer, guess again. "
  else
    if [[ $INPUT >> $RANDOM ]]
    then
       
done