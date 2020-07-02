Feature: View profile

Scenario: Basic profile
  Given I am signed out
  And a user exists with a basic profile
  When I visit the path that is that user's slug
  Then I should not see the navbar
  And I should see a 'hello' card with the user's personal name and pronouns
  And I should see a box with the full name
  And I should see a usage guide for one set of pronouns
  And I should not see the formal name
  And I should not see a pronunciation guide
  And I should see a link to the main site
  
Scenario: Profile with text features filled out
  Given I am signed out
  And a user exists with a detailed profile
  When I visit the path that is that user's slug
  Then I should not see the navbar
  And I should see a 'hello' card with the user's personal name and pronouns
  And I should see a box with the full name
  And I should see a pronunciation guide
  And I should see the formal name
  And I should see a link to the main site
  
Scenario: Profile with multiple pronouns
  Given I am signed out
  And a user exists with a basic profile
  And the user has multiple pronoun sets
  When I visit the path that is that user's slug
  Then I should see all the pronoun sets on one line each
  And I should see usage guides for all sets of pronouns

Scenario: Cannot view incomplete profile
  Given I am signed out
  And a user exists who has not completed their profile
  When I visit the path that is that user's slug
  Then I should be redirected to the homepage with a forbidden error
