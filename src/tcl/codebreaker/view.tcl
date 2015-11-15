#!/usr/bin/env tclsh
#package provide CodeBreaker 1.0

 ##
 #  @package   codebreaker
 #  @file      view.tcl
 #  @brief     Codebreaker view of MVC
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

#namespace eval CodebreakerView {
#}

 ##
 #  @fn      userinit
 #  @brief   User-defined constructor
##
proc userinit {} {
   #debugNamespace
   variable model 
   Model create model
}

 ##
 #  @fn      addList
 #  @param   text Text item to be added to the list
 #  @brief   Callback to handle button_4 widget option -command
##
proc addList { text } {
    
   global guiNameSpace
    if { $guiNameSpace == "spectcl_codebreaker" } {
        set listBox ._listbox_1	
    }
    if { $guiNameSpace == "vtcl_codebreaker" } {
        set listBox .top43.lis48	
    }

    # Deselect the old last entry
    $listBox selection clear end
    # Add an entry
    $listBox insert end $text
    # Scrall at the end of the list
    $listBox see end
    # mark last item
    $listBox selection set end
    return $text
}

 ##
 #  @fn      getGuess
 #  @brief   Get a guess from input field
 #  @return  Guess
##
proc getGuess {} {
    global guiNameSpace
    if { $guiNameSpace == "spectcl_codebreaker" } {
	set entry1 ._entry_1	
    }
    if { $guiNameSpace == "vtcl_codebreaker" } {
        set entry1 .top43.ent47	
    }
    # Get data from input field
    set result [$entry1 get]
    return $result
}

 ##
 #  @fn      clearListbox
 #  @brief   Clear listbox
##
proc clearListbox {} {

    global guiNameSpace
    if { $guiNameSpace == "spectcl_codebreaker" } {
        set listBox ._listbox_1	
    }
    if { $guiNameSpace == "vtcl_codebreaker" } {
        set listBox .top43.lis48	
    }

    # Clear listbox
   $listBox delete 0 end
}

 ##
 #  @fn      exitCmd
 #  @brief   Exit
##
proc exitCmd {} {
   # Delete codebreaker object
   destroy
   exit
}

 ##
 #  @fn      aboutCmd
 #  @brief   About
##
proc aboutCmd {} {
    set text \
"Codebreaker - Guess 4 secret numbers right. \
(c) Rolf Hemmerling 2015 - GNU LESSER GENERAL \
PUBLIC LICENSE Version 2.1"
    addList $text
    return $text
}


 ##
 #  @fn      newGameCmd
 #  @brief   New Game
##
proc newGameCmd {} {
   variable model
   model gameOver 0
    # Clear listbox
   clearListbox
   model generateSecretnumber
   addList "New Game"
}

 ##
 #  @fn      guessCmd
 #  @brief   Guess
##
proc guessCmd {} {
   variable model
   set result ""
   set guessOfPlayer [getGuess]
   if {[string length $guessOfPlayer] < 4}  {
       set result ""
   } else {
       if {[model gameOver] == 1} {
	   set result ""
      } else {
	    set codedResult [model guessSecretnumber $guessOfPlayer]
	   set gameOver2 [model guessIsCorrect $guessOfPlayer]
	    model gameOver $gameOver2
	   set result [append guessOfPlayer ": " $codedResult]
	   if {$gameOver2 == 1} {
	       set result [append result " >You won!"]
	   }
	   addList $result
       }
   } 	 
   return $result
}

#
#
# Menu only commands
#

 ##
 #  @fn      newSelfdefinedGame
 #  @brief   New Game with User-Defined Secret Number
##
proc newSelfdefinedGame {} {
    variable model secretnumber
    set secretnumber [getGuess]
    model gameOver 0
    # Clear listbox
    clearListbox
    set text [model setSecretnumber $secretnumber]
    addList [append "Demo Game =" $text]
}

 ##
 #  @fn      hintCmd
 #  @brief   Hint
##
proc hintCmd {} {
   variable model
   set result [model getSecretnumber]
   addList [append "Hint = " $result]
   return result
}

 ##
 #  @fn      button1Cmd_command
 #  @brief   Button #1 command
##
proc ::button1Cmd_command args {
    vtcl_codebreaker::guessCmd
}

 ##
 #  @fn      button2Cmd_command
 #  @brief   Button #2 command
##
proc ::button2Cmd_command args {
    vtcl_codebreaker::newGameCmd
}

 ##
 #  @fn      button3Cmd_command
 #  @brief   Button #3 command
##
proc ::button3Cmd_command args {
    vtcl_codebreaker::aboutCmd
}

 ##
 #  @fn      button4Cmd_command
 #  @brief   Button #4 command
##
proc ::button4Cmd_command args {
    vtcl_codebreaker::exitCmd
}

 ##
 #  @fn      exitCmd
 #  @brief   Exit
##
proc ::exitCmd {} {
   vtcl_codebreaker::exitCmd
}

 ##
 #  @fn      newGameCmd
 #  @brief   New Game
##
proc ::newGameCmd {} {
   vtcl_codebreaker::newGameCmd
}

 ##
 #  @fn      guessCmd
 #  @brief   Guess
##
proc ::guessCmd {} {
   vtcl_codebreaker::guessCmd
}

 ##
 #  @fn      newSelfdefinedGame
 #  @brief   New Game with User-Defined Secret Number
##
proc ::newSelfdefinedGame {} {
    vtcl_codebreaker::newSelfdefinedGame
}

 ##
 #  @fn      hintCmd
 #  @brief   Hint
##
proc ::hintCmd {} {
   vtcl_codebreaker::hintCmd
}

#}

 ##
 #   @fn    main
 #   @brief main
##
debugPuts "File 'View'"
