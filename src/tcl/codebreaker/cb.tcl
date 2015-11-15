#!/usr/bin/env tclsh
package provide CodeBreaker 1.0
global appDirPath
set appDirPath [file dirname [info script]]
lappend auto_path $appDirPath 
global DEBUG
#set DEBUG 1

 ##
 #  @package   codebreaker
 #  @file      cb.tcl
 #  @brief     CodeBreaker, command line tool to select the implementation
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

global debugNamespace
global debugPuts
# 'set guiPath "vtcl_cb.tcl"'
set debugPath $appDirPath
append debugPath "/debug.tcl"
source $debugPath

namespace eval CodebreakerCb {

  namespace export pkgIndex
  namespace export guiSelector
  namespace export vtcl spectcl

   ##
   #   @fn    spectcl
   #   @brief GUI Selector SpecTCL
  ##  
  proc pkgIndex {} {
    global argc
    global argv
    set fail [catch {set argc} resultOfScript]
    if {[expr $fail]} {
       set argc 0
       set argv {""}
    }
  }

   ##
   #   @fn    spectcl
   #   @brief GUI Selector SpecTCL
  ##
  proc spectcl {} {
    # globals for "spectcl_cb.tcl":
    global appDirPath
    # 'set guiPath "spectcl_cb.tcl"' 
    set guiPath $appDirPath
    append guiPath "/spectcl_cb.tcl"
    source $guiPath
    variable guiInit
    $guiInit .
  }

    ##
    #   @fn    vtcl
    #   @brief GUI Selector VTCL
   ##
  proc vtcl {} {
    # globals for "vtcl_cb.tcl":
    global appDirPath
    # globals for "vtcl_codebreaker.tcl":
    global tcl_platform
    global platform
    global argc
    global argv

    # 'set guiPath "vtcl_cb.tcl"'
    set guiPath $appDirPath
    append guiPath "/vtcl_cb.tcl"
    source $guiPath
  }

   ##
   #   @fn    guiSelector
   #   @brief GUI Selector
  ##
  proc guiSelector {} {
    global argc
    global argv
    if { $argc == 1} { 
        set selectedGui [lindex $argv 0]   	
        if { $selectedGui == "spectcl" } {
	    spectcl 
        } 
        if { $selectedGui == "vtcl" } {
	    vtcl
        }
    }
  }

}

 ##
 #   @fn    main
 #   @brief main
##
debugPuts "File 'Cb'"

namespace eval CodebreakerCb {
  debugNamespace CodebreakerCb
  pkgIndex
  guiSelector	
}

#
# Is this script called by TCLSH directly?
#
if {[info script] eq $argv0} {
    debugPuts "Codebreaker!"	
}
