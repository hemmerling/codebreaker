#!/usr/bin/env tclsh

##
#  @package   codebreaker
#  @file      cb_call2.tcl
#  @brief     CodeBreaker, call of the command line tool
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

global DEBUG
set DEBUG 1

#
# auto_path is updated by adding a path 
# to the individual directory 
# of your application in your filesystem 
# to the environment variable TCLLIBPATH
#
# TCLLIBPATH is a Tcl-style whitespace-delimiter list, 
# not a shell-style colon-delimiter list
#
package require CodeBreaker
namespace import ::CodebreakerCb::*
global spectcl
spectcl
#global vtcl
#vtcl
