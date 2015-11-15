#!/usr/bin/env tclsh
#package provide CodeBreaker 1.0

 ##
 #  @package   codebreaker
 #  @file      model.tcl
 #  @brief     Codebreaker model of MVC
 #  @author    Rolf Hemmerling <hemmerling@gmx.net>
 #  @date      2015-11-01
 #  @copyright GNU LESSER GENERAL PUBLIC LICENSE, Version 2.1
 #
 #  codebreaker - Tcl number-guessing game application "CodeBreaker"
 #
 #  Copyright 2015 Rolf Hemmerling
 #
 #  Licensed under the GNU LESSER GENERAL PUBLIC LICENSE, Version 2.1
 #  (the "License"); you may not use this file except in compliance with
 #  the License. You may obtain a copy of the License at
 #
 #  http://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html
 #
 #  Unless required by applicable law or agreed to in writing, software
 #  distributed under the License is distributed on an "AS IS" BASIS,
 #  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 #  See the License for the specific language governing permissions and
 #  limitations under the License.
##

#namespace eval CodebreakerModel {

 #
 #  @class   CbIo
 #  @brief   CodeBreaker Input / Output
##
::oo::class create CbIo {

     ##
     #	@fn      constructor
     #	@brief   Constructor
    ##
    constructor {} {
        catch {now}  
    }   

    destructor {
	catch {now}
    }

     ##
     #  @fn      welcome_message
     #  @brief   Welcome message
    ##
    method welcome_message {} {
        set output "Welcome to Codebreaker!"
        return $output
    }

     ##
     #  @fn      askfor_guess
     #  @brief   Ask for a guess
    ##
    method askforGuess {} {
        set output "Enter guess:"
        return $output
    }
}

 ##
 #  @class   Model
 #  @brief   CodeBreaker model of MVC
##
::oo::class create Model {
	
    variable secretNumber
    variable defaultSecretnumber
    variable applicationTitle
    variable gameOverStatus
    variable codebreaker

     #
     #	@fn      constructor
     #  @param   status Status whether the game is over
     #                  Default: 0
     #	@brief   Constructor
    ##
    constructor {{status 0}} {
	variable codebreaker
        set gameOverStatus $status
        set defaultSecretnumber "1234"
        set applicationTitle "Codebreaker"
	set menuOptions [dict create]
        dict append menuOptions 0 "New Game"
	dict append menuOptions 1 "New Game with user-defined Secret Number"
	dict append menuOptions 2 "About"
	dict append menuOptions 3 "Exit"
	my setSecretnumber $defaultSecretnumber  
	CodeBreaker create codebreaker
	catch {now}
    }   

    destructor {
        catch {now}
    }

     ##
     #  @fn      generateSecretnumber
     #  @brief   Generate a secret number (0,9999)
     #  @return  Secret number
    ##
    method generateSecretnumber {} {
        variable secretNumber
	set secretNumber [expr round(rand() * 10000)]
        return $secretNumber
    }
	
     ##
     #  @fn      setSecretnumber
     #  @brief   Set the secret number
     #  @param   secretNumber Secret number
    ##
    method setSecretnumber {secretNumber2} {
        variable secretNumber
 	set secretNumber $secretNumber2
        return $secretNumber
    }

     ##
     #  @fn      getSecretnumber
     #  @brief   Get the secret number
     #  @return  Secret number
    ##
    method getSecretnumber {} {
	variable secretNumber
	return $secretNumber
    }
	
     ##
     #  @fn      guessSecretnumber
     #  @brief   Guess the secret number
     #  @return  Result of the guess
    ##
    method guessSecretnumber {secretNumber} {
	variable codebreaker
        codebreaker start [my getSecretnumber]
        set result [codebreaker guess $secretNumber]
        return $result
    }

     ##
     #  @fn      guessIsCorrect
     #  @brief   Check if the guess is correct
     #  @return  Is the guess correct?
    ##
    method guessIsCorrect {secretNumber} {
	set result 0
        if { $secretNumber == [my getSecretnumber] } {
            set result 1
        } else {
	    set result 0
	}
        return $result
   }
	
     ##
     #  @fn      gameOver
     #  @brief   Set status that game is over, or not
     #  @param   status. Default value: None
	     
     #  @return  status None Status of game
    ##
    method gameOver {{status -1}} {
        variable gameOverStatus
	if {$status != -1} {
            set gameOverStatus $status
        }
	return $gameOverStatus
    }
}

#}

##
#   @fn    main
#   @brief main
##
debugPuts "File 'Model'"

