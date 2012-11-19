Feature: Schedule management
  Scenario: Adding a new course
    Given I have an account
    And I'm logged in
    When I enter my course information
    And I enter my schedule for the course
    Then I should have the course in my schedule
