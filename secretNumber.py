#!/usr/bin/python
# This is a guessing game
# The player has 10 tries to guess the correct secret_number
# The number is between 0 and 100 including both extremes.
# After each guess the program will say whether the answer is too low,
# too high, or correct. After 10 guesses or one correct guess
# the game will end. At the end of the game the program will say the
# player has won or lost.
#
# Notes:
# running on ubuntu kernel version 4.15.0-32-generic
# Python version 2.7.15rc1
# This is just a game. No effort was made to use a truly random number
#

from random import randint


secret_number = randint (0,100)
guess=-1
loopCount=0

print("Let's play a game.")
print("I've picked an integer number i where: 0 <= i <= 100.")
print("You have 10 tries to guess what it is.")
#print("debug:" +str(secret_number))

while (loopCount < 10) and (secret_number != guess):
            #guess = get a guess input from player
            guess = input("Please enter guess # " +str(loopCount + 1)+ ": " )
            guess = int(float(guess))
            #print("debug:" +str(guess)+ " ?? " +str(secret_number) )

            # check if sercret number is correct
            if guess < secret_number:
                print('your guess: ' +str(guess)+ ' is low')
            elif guess > secret_number:
                print('your guess: ' +str(guess)+ ' is high')
            else:
                print ('you guessed right!')

            loopCount = loopCount +1

print "\nThe game is over"
if secret_number == guess:
    print("\nYou have Won.")
else:
    print ("\nYou have lost.")
