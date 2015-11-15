#!/usr/bin/env tclsh
#package provide CodeBreaker 1.0
set appDirPath [file dirname [info script]]

 ##
 #  @package   codebreaker
 #  @file      spectcl_cb.tcl
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

 ##
 #   @fn    main
 #   @brief main
##
debugPuts "File 'SpectclCb'"

variable guiInit
global guiNameSpace
set guiNameSpace "spectcl_codebreaker"
set guiDriver "spectcl_codebreaker.tcl"
set guiInit "spectcl_codebreaker::init"

# Reset to main namespace
namespace eval :: {
  # Set relative namespace ( = relative to main namespace )
  namespace eval $guiNameSpace {
    # globals for "vtcl_codebreaker.tcl":
    global tcl_platform
    global platform
    global argc
    global argv

    proc pkgIndex {} {
      global argc
      global argv
      set fail [catch {set argc} resultOfScript]
      if {[expr $fail]} {
         set argc 0
         set argv {""}
      }
    }
    pkgIndex

    # "source view.tcl"
    set viewPath $appDirPath
    append viewPath "/view.tcl"
    source $viewPath
	  
    debugNamespace "guiNameSpace_is" $guiNameSpace
  }
}

namespace eval SpectclCb {
  variable guiInit
  variable model

  # "source model.tcl"
  namespace eval :: {	
    set modelPath $appDirPath
    append modelPath "/model.tcl"
    source $modelPath
  }
  namespace import ::oo:::Model  
		
  # "source codebreaker.tcl"
  namespace eval :: {	
    set codebreakerPath $appDirPath
    append codebreakerPath "/codebreaker.tcl" 
    source $codebreakerPath
  }
  namespace import ::oo:::CodeBreaker

  debugNamespace "SpectclCb"
	
  # "source $guiDriverPath"
  namespace eval :: {	
    set guiDriverPath $appDirPath
    append guiDriverPath "/spectcl_codebreaker.tcl"
    variable guiDriverPath
    source $guiDriverPath
  }
}



