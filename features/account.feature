Feature: Account management
  Scenario: Creating an account
    Given I do not have an account
    When I enter my information
    And I confirm my e-mail address
    Then I should be able to login
