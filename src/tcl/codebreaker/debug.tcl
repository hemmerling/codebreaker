#!/usr/bin/env tclsh
#package provide CodeBreaker 1.0

 ##
 #  @package   codebreaker
 #  @file      debug.tcl
 #  @brief     CodeBreaker, procedures for debugging
 #  @author    Rolf Hemmerling <hemmerling@gmx.net>
 #  @date      2015-09-15
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

global debugNamespace
global debugPuts

 ##
 #  @fn          debugNamespace
 #  @brief       Display namespace infos
 #  @param args  Extra debugging message to be dispayed
##
proc debugNamespace {args} {
    global DEBUG
    if {[info exists DEBUG] && $DEBUG} {
      puts $args
      puts [namespace current]
      puts [namespace children]
      #puts [info commands]
      #puts [info functions]
    }
}

 ##
 #  @fn          debugPuts
 #  @brief       Display debugging message
 #  @param args  Debugging message to be dispayed
##
proc debugPuts {args} {
    global DEBUG
    if {[info exists DEBUG] && $DEBUG} {
      puts $args
    }
}
