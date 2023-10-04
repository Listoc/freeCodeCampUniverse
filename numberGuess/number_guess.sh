#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
RANDOM_NUMBER=$(($RANDOM % 1000 + 1))
echo Enter your username:
read USERNAME
USERNAME_INFO=$($PSQL "SELECT games_played, best_game FROM users WHERE username='$USERNAME'")
if [[ -z $USERNAME_INFO ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_RESULT=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
else
  echo "$USERNAME_INFO" | while IFS="|" read GAMES_PLAYED BEST_GAME
  do
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi


FLAG=0
COUNTER=0
echo Guess the secret number between 1 and 1000:
while [[ $FLAG != 1 ]]
do
  COUNTER=$(($COUNTER + 1))
  read NUMBER
  if [[ ! "$NUMBER" =~ ^[0-9]+$ ]]
  then
    echo That is not an integer, guess again:
  
  elif [[ $NUMBER -lt $RANDOM_NUMBER ]]
  then
    echo "It's higher than that, guess again:"
  elif [[ $NUMBER -gt $RANDOM_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
  else
    FLAG=1
  fi
done

UPDATE_RESULT=$($PSQL "UPDATE users SET games_played = games_played + 1 WHERE username='$USERNAME'")
UPDATE_RESULT=$($PSQL "UPDATE users SET best_game = $COUNTER WHERE username='$USERNAME' AND (best_game > $COUNTER OR best_game IS NULL)")
echo "You guessed it in $COUNTER tries. The secret number was $RANDOM_NUMBER. Nice job!"
