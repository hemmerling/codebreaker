##
#
#  @package codebreaker
#  @file    codebreaker_start_game.feature
#  @date    2010-11-11
#

Feature: code-breaker starts game

  As a code-breaker
  I want to start a game
  So that I can break the code

  @StartGame
  Scenario: start game
    Given I am not yet playing
    When I start a new game
    Then I should see "Welcome to Codebreaker!"
    And I should see "Enter guess:"
