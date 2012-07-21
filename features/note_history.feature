Feature: check my notes

  As an Anotar user
  I want to read my added notes
  So that I can remember the stuff I added

Background: I'm on the right place
  Given I am on the Anotar home page

Scenario: one note added, user not logged in
  Given I am not logged in
  When I add a new note "This is a test"
  And I go to the Anotar home page
  Then I should see the note added "This is a test"

Scenario: one note added, user logged in
  Given I'm logged in as "Zodiac"
  When I add a new note "This is a test"
  And I go to the Anotar home page
  Then I should see "Hello, Zodiac"
  And I should see a note added "This is a test"

Scenario: notes added, user not logged in
  Given I am not logged in
  When I add a new note "This is a test 1"
  And I add a new note "This is a test 2"
  And I go to the Anotar home page
  Then I should see the note added "This is a test 1"
  And I should see the note added "This is a test 2"

Scenario: notes added, user logged in
  Given I'm logged in as "Zodiac"
  When I add a new note "This is a test"
  And I go to the Anotar home page
  Then I should see "Hello, Zodiac"
  And I should see the note added "This is a test 1"
  And I should see the note added "This is a test 2"

Scenario: no notes added, user not logged in
  Given I am not logged in
  Then I should see the notice "Hello there, add a new note!"

Scenario: no notes added, user logged in
  Given I'm logged in as "Zodiac"
  Then I should see the notice "Hello there, add a new note!"