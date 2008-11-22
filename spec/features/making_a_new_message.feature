Feature: Making a new message
  In order to to be able to send a message
  Users should be able to
  Create a message object
  
  Scenario: Making a basic plain text email from a string
    Given a basic email in a string
    When I parse the basic email
    Then the 'from' field should be 'bob'

    | attribute   | value |
    | to          | mikel |
    | subject     | Hello! |
    | body        | email message |
