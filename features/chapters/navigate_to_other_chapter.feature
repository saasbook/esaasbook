Feature: Customer can visit other chapters/sections through clickable content

	As a customer
	I want to navigate to other chapters/sections
	So that I can read the text

Scenario: Navigate to chapter 1 section 0 from chapter 0 section 0 first

	Given I am on chapter 0 section 0
	When I follow the first "Introduction to Software as a Service, Agile Development, and Cloud Computing"
	Then I should be on chapter 1 section 0

Scenario: Navigate to chapter 1 section 0 from chapter 0 section 0 second

	Given I am on chapter 0 section 0
	When I follow the second "Introduction to Software as a Service, Agile Development, and Cloud Computing"
	Then I should be on chapter 1 section 0
