Explicit vs. Implicit and Imperative vs. Declarative Scenarios 
====================================

Now that we have seen user stories and Cucumber in action, we are ready to cover two important testing topics 
that involve contrasting perspectives.

The first is *explicit versus implicit requirements*. A large part of the formal specification in plan-and-document 
is requirements, which in BDD are user stories developed by the stake- holders. Using the terminology from Chapter 1, 
they typically correspond to acceptance tests. Implicit requirements are the logical consequence of explicit requirements, 
and typically cor- respond to what Chapter 1 calls integration tests. An example of an implicit requirement in 
RottenPotatoes might be that by default movies should be listed in chronological order by release date.

The good news is that you can use Cucumber to kill two birds with one stone—create acceptance tests *and* integration 
tests—if you write user stories for both explicit and implicit requirements. (The next chapter shows how to use 
another tool for unit testing.)

To see why, suppose we want to write a feature that specifies that movies should appear
in alphabetical order on the list of movies page. For example, “Zorro” should appear after
“Apocalypse Now”, even if “Zorro” was added first. It would be the height of tedium to
express this scenario naively, because it mostly repeats lines from our existing “add movie”
scenario—not very DRY:

.. code-block:: cucumber

    Feature: movies should appear in alphabetical order, not added order

    Scenario: view movie list after adding 2 movies (imperative and non-DRY)

        Given I am on the RottenPotatoes home page
        When I follow "Add new movie"
        Then I should be on the Create New Movie page
        When I fill in "Title" with "Zorro"
        And I select "PG" from "Rating"
        And I press "Save Changes"
        Then I should be on the RottenPotatoes home page
        When I follow "Add new movie"
        Then I should be on the Create New Movie page
        When I fill in "Title" with "Apocalypse Now"
        And I select "R" from "Rating"
        And I press "Save Changes"
        Then I should be on the RottenPotatoes home page
        Then I should see "Apocalypse Now" before "Zorro" on the RottenPotatoes home page sorted by title

Cucumber is supposed to be about *behavior* rather than implementation—focusing on
*what* is being done—yet in this poorly-written scenario, only line 18 mentions the behavior of interest!

An alternative approach is to think of using the step definitions to make a *domain language* (which is different 
from a formal **Domain Specific Language (DSL)**) for your application. A domain language is informal but uses terms 
and concepts specific to your application, rather than generic terms and concepts related to the implementation 
f the user interface. Steps written in a domain language are typically more declarative than imperative in that 
they describe the state of the world rather than the sequence of steps to get to that state and they are less 
dependent on the details of the user interface.

A declarative version of the above scenario might look like this:

.. code-block:: cucumber

    Given /I have added "(.*)" with rating "(.*)"/ do |title, rating|
        steps %Q{
            Given I am on the Create New Movie page
            When  I fill in "Title" with "#{title}"
            And   I select "#{rating}" from "Rating"
            And   I press "Save Changes"
        }
    end

    Then /I should see "(.*)" before "(.*)" on (.*)/ do |string1, string2, path|
        steps %Q{Given I am on #{path}}
        regexp = /#{string1}.*#{string2}/m #  /m means match across newlines
        expect(page.body).to match(regexp)
    end

The declarative version is obviously shorter, easier to maintain, and easier to understand since the text 
describes the state of the app in a natural form: “I am on the RottenPotatoes home page sorted by title.”

.. code-block:: cucumber

    Feature: movies should appear in alphabetical order, not added order

    Scenario: view movie list after adding movie (declarative and DRY)

        Given I have added "Zorro" with rating "PG-13"
        And   I have added "Apocalypse Now" with rating "R"
        Then  I should see "Apocalypse Now" before "Zorro" on the RottenPotatoes home page sorted by title

The good news is that, as Figure 7.5 shows, you can reuse your existing imperative steps to implement such 
scenarios. This is a very powerful form of reuse, and as your app evolves, you will find yourself reusing 
steps from your first few imperative scenarios to create more concise and descriptive declarative scenarios. 
Declarative, domain-language-oriented scenar- ios focus the attention on the feature being described rather 
than the low-level steps you need to set up and perform the test.

**Self-Check 7.8.1.** *True or False: Explicit requirements are usually defined with imperative scenarios and 
implicit requirements are usually defined with declarative scenarios.*

    False. These are two independent classifications; both requirements can use either type of scenarios.
            