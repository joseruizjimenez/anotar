Feature: create a new note (anotar)

  As an Anotar user
  I want to create a new note
  So that I can remember my stuff

Background: I'm on the right place
  Given I am on the Anotar home page

Scenario: user not loged in, successful submission
  Given I am not logged in
  When I add a new note "This is a test"
  Then I should see the Anotar home page
  And the notice "New note added!"

Scenario: user loged in, successful submission
  Given I'm logged in as "Zodiac"
  When I add a new note "This is a test"
  Then I should see the Anotar home page
  And the notice "New note added!"

Scenario: failed submission with empty note
  When I add a new note ""
  Then I should see the Anotar home page
  And the notice "Write something first!"