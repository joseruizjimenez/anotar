Feature: user can sign in and sign out

  As a registered user
  I want to sign in into my account
  So that I can sign out when I'm done

Background: users already registered
  Given the following users exist:
  | user     | pass     | email              |
  | Zodiac   | 1d4rio3% | zodiac@gmail.com   |
  | Calabaza | 9klk&_e3 | calabaza@anotar.me |

  And I am on the Anotar home page

Scenario: successful login with user

Scenario: successful login with email

Scenario: wrong username or pass

Scenario: successful logout