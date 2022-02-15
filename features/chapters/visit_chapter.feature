Feature: Customer can visit each chapter/section page

	As a customer
	I want to visit each chapter/section page
	So that I can read the text

Scenario Outline: Visit chapter <chapter> section <section>

	Given I am on chapter <chapter> section <section>
	Then I should see <text>

	Examples:
		| chapter | section | text |
		| 0 | 0 | "If you want to build a ship, don’t drum up the men to gather wood, divide the work and give orders. Instead, teach them to yearn for the vast and endless sea." |
		| 3 | 0 | "3.1.1 Introduction" |
		| 6 | 1 | "We will stake out a conservative position in this introduction and introduce enhancing SaaS with unobtrusive JavaScript and the jQuery library. In general, unobtrusive JavaScript emphasizes:" |
