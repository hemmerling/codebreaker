#!/usr/bin/env tclsh

##
#  @package   codebreaker
#  @file      all.bat
#  @brief     Tests for the Tcl/Tk application "Codebreaker"
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

package require tcltest
namespace import ::tcltest::*
# tcltest::debug 3
# tcltest::verbose "body pass skip start error"
runAllTests
