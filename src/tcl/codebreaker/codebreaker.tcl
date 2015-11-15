#!/usr/bin/env tclsh
#package provide CodeBreaker 1.0

 ##
 #  @package   codebreaker
 #  @file      codebreaker.tcl
 #  @brief     Tcl/Tk application "Codebreaker"
 #  @author    Rolf Hemmerling <hemmerling@gmx.net>
 #  @version   1.00
 #  @date      2015-11-01
 #  @copyright GNU LESSER GENERAL PUBLIC LICENSE Version 2.1
 #
 #  codebreaker - Tcl/Tk application "Codebreaker"
 #
 #  Copyright 2015 Rolf Hemmerling
 #
 #  Licensed under the GNU LESSER GENERAL PUBLIC LICENSE Version 2.1 
 #  (the "License") you may not use this file except in compliance 
 #  with the License. You may obtain a copy of the License at
 #
 #  http://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html
 #
 #  Unless required by applicable law or agreed to in writing, software
 #  distributed under the License is distributed on an "AS IS" BASIS,
 #  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 #  See the License for the specific language governing permissions and
 #  limitations under the License.
##

::oo::class create CodeBreaker {
 
    # As of TCOO 8.6, 
    # variables must be defined by a single statment :-(
    variable sign_plus 
    variable sign_minus 
    variable space 
    variable code 
    variable dictionary
	
     ##
     #  @fn      constructor
     #  @brief   Constructor
    ##
    constructor {} {
	variable sign_plus
	variable sign_minus 
	variable space 
	variable code 
	variable dictionary
        set sign_plus "+"
        set sign_minus "-"
        set space ""
        set code 0
        set code_as_dictionary [dict create ]
	set dictionary [dict create]
	catch {now}
    }

    destructor {
        catch {now}
    }
	
     ##
     #  @fn          start
     #  @brief       Start a new game
     #  @param code  The code string
     #  @return      The code as dictionary
    ##
    method start { code2 } {
	variable code
	set code $code2
    	set code_as_dictionary [ my data2Dictionary $code2 ]
	return $code_as_dictionary   
    }

     ##
     #  @fn         data2Dictionary
     #  @brief      Convert the data to a dictionary
     #  @param data The data
     #	@return     The data as dictionary
     #  @return     The code as dictionary
    ##
    method data2Dictionary { data } {
        set dictionary [dict create]
	set data2 [my string2list $data] 
	foreach jj $data2 {
	    if { [dict exist $dictionary $jj] } {
		 # dict update doesn't work with class variables :-(:
		 # dict update dictionary $jj [expr [dict get $dictionary $jj] + 1]
		 # This works with class variables too...:
		 set dictionary [dict replace $dictionary $jj \
		 		[expr [dict get $dictionary $jj] + 1]]
	    } else {
		dict lappend dictionary $jj 1
	    }
	}
        return $dictionary
    }

     ##
     # @fn           getRightPositions
     # @brief        Get the right positions
     # 	             Assumption: Length of both strings is equal
     # @param code2  The code
     # @param guess2 The guess2
     # @return       Number of right positions
    ##
    method getRightPositions { code2 guess2 } {
	set result 0
	for { set iii 0 } { $iii < [string length $code2] } { incr iii } {
	      if { [string index $code2 $iii] ==
		   [string index $guess2 $iii] } {
		incr result
    	      }
        }
	return $result
    }

     ##
     #  @fn      string2list
     #  @brief   Create an array from a string
     #  @param   guess String, e.g. "1234"
     #  @return  List, e.g {"1" "2" "3" "4"}
    ##
    method string2list {guess2} {
        set resultList []
        set result2 ""
        set def "%s"
        set guess3 [format $def $guess2]
        for { set jj 0 } { $jj < [string length $guess3] } { incr jj } {
	    set result [string range $guess3 $jj $jj]
	    lappend resultList $result
        }
        return $resultList
    }

     ##
     #  @fn      getRightNumbers
     #  @brief   Get the right numbers
     #           Sticky: If there are 2 guesses for a number
     #           which appears just once in the code,
     #	         the feedback is '1' and not '2'
     #  @param   code2 The code dictionary
     #  @param   guess2 The guess2
     #  @return  Number of right numbers
     #
     #  get_right_numbers. Sticky: If there are 2 guesses for a number
     #  which appears just once in the code, the feedback is '1' and not '2'
    ##
    method getRightNumbers { code2 guess2 } {
	set result 0
	set resultOfScript 0
	set iii 0
	set guessDictionary [my data2Dictionary $guess2]
	foreach jj [dict key $guessDictionary] {
	    set numberOfGuesses [dict get $guessDictionary $jj]
	    set fail [catch {dict get $code2 $jj} resultOfScript]
	    if {[expr !$fail]} {
	       set numberOfFoundItems [dict get $code2 $jj]
	      incr result $numberOfFoundItems
	    } else {
	    }
	}
	return $result
   }
	
    method getRightNumbers2 { code2 guess2 } {
        set result 0
        set resultOfScript 0
        set iii 0
        set guessDictionary [my data2Dictionary $guess2]
        foreach jj [dict key $guessDictionary] {
	    set numberOfGuesses [dict get $guessDictionary $jj]
	    set fail [catch {dict get $code2 $jj} resultOfScript]
	    if {[expr !$fail]} {
	        set numberOfFoundItems [dict get $code2 $jj]
	        incr result $numberOfFoundItems
	    } else {
		#
	    }
        }
        return $result
    }

    ##
    #  @fn      getNumberOfWrongPos
    #  @brief   Get the number of wrong positions
    #  @param   code2  The code
    #  @param   guess2 The guess
    #  @param   number Number of right positions
    #  @return  Number of wrong positions
    #  
    #  It is not necessary to implement this algorithm for each symbol,
    #  as there is a more simple implementation:
    #
    #	if  ( number of items of the symbol in code > 
    #  	      number of right positions of the symbol in guess )
    #      then	
    #        if ( Number of items of the symbol in guess >
    #             Number of items of the symbol in code )
    #           then
    #            Number of wrong positions of a symbol := 
    #            Number of items of the symbol in code
    #           else
    #            Number of wrong positions of a symbol := 
    #            Number of items of the symbol in guess
    #      else
    #        Number of wrong positions of a symbol := 0
    #
   ##
   method getNumberOfWrongPos { code2 guess2 number } {
       set codeAsDictionary [my data2Dictionary $code2]
       set number2 [my getRightNumbers $codeAsDictionary $guess2]
       set result [expr $number2 - $number]
       return $result
   }

    ##
    #  @fn      getNumberOfSigns
    #  @brief   Get the number of signs
    #  @param   number  Number
    #  @param   sign The sign character
    #  @return  Number of signs
   ##
   method getNumberOfSigns { number sign2 } {
       set result $space
       for { set iii 0 } { $iii < $number } { incr iii } {
 	   append result $sign2
       }
       return $result
   }

    ##
    #  @fn      guess
    #  @brief   guess
    #  @param   guess2 The user input with the guess by the user
    #  @return  Result of guess2
   ##
   method guess { guess2 } {
        variable sign_plus
        variable sign_minus 
	variable code
	set mark_plus [my getRightPositions $code $guess2]
	set result [my getNumberOfSigns $mark_plus $sign_plus]
	set mark_minus [my getNumberOfWrongPos $code $guess2 $mark_plus]
	set xx  [my getNumberOfSigns $mark_minus $sign_minus]
	append result $xx
	return $result

    }

}

 ##
 #   @fn    main
 #   @brief main
##

debugPuts "File 'Codebreaker'"

