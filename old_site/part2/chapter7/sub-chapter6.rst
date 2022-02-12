Cucumber: From User Stories to Acceptance Tests
====================================
Remarkably enough, the tool **Cucumber** turns customer-understandable user stories into **acceptance tests**, which 
ensure the customer is satisfied, and **integration tests**, which ensure that the interfaces between modules have 
consistent assumptions and communicate correctly. (Chapter 1 describes types of testing.) The key is that Cucumber 
meets halfway between the customer and the developer: user stories don’t look like code, so they are clear to the 
customer and can be used to reach agreement, but they also aren’t completely freeform. This section explains how 
Cucumber accomplishes this minor miracle.

In the Cucumber context we will use the term **user story** to refer to a single **feature** with one or more **scenarios** 
that show different ways a feature is used. The keywords :code:`Feature` and :code:`Scenario` identify the respective components. 
Each scenario is in turn composed of a sequence of typically 3 to 8 *steps*. Expanding a user story into a set of 
scenarios also helps developers enumerate the various user-visible conditions that will be tested to ensure the 
feature works. For example, consider a fictitious e-commerce site that wants developers to implement the feature 
*Customer can use “guest checkout” to make a purchase without creating an account*. This might be broken down into 
several scenarios:

• Customer can complete a purchase as guest
• Customer cannot do a guest purchase if the order includes a gift
• Multiple guest checkouts associated with same email address group the orders into the same account

Notice in particular the third scenario, which might arise from conversation with the customer while discussing the 
feature: “Well, what happens if the same email address appears on multiple orders but that user has no account? Should 
we associate those orders with the same customer internally?” Indeed, such discussions are vital to fleshing out 
ambiguities in the customer’s desired features.

.. code-block:: cucumber

    Feature: Add a movie to RottenPotatoes
             As a movie fan
             So that I can share a movie with other movie fans
             I want to add a movie to RottenPotatoes database
    Scenario: Add a movie
        Given I am on the RottenPotatoes home page
        When I follow "Add new movie"
        Then I should be on the Create New Movie page
        When I fill in "Title" with "Hamilton"
        And I select "PG-13" from "Rating"
        And I select "July 4, 2020" as the "Released On" date
        And I press "Save Changes"
        Then I should be on the RottenPotatoes home page
        And I should see "Hamilton"

Figure 7.4 is an example user story, showing a feature with one scenario of adding the movie *Hamilton*; the scenario has 
nine steps. (We show just a single scenario in this example, but features usually have many scenarios.) Although stilted 
writing, this format that Cucumber can act upon is still easy for the nontechnical customer to understand, providing a
common representation of the story on which the customer and team can now collaborate — a founding principle of Agile and BDD.

Each step of a scenario starts with its own keyword. Steps that start with :code:`Given` usually set up some preconditions, such 
as navigating to a page. Steps that start with :code:`When` typically use one of Cucumber’s built-in web steps to simulate the user 
pressing a button, for example. Steps that start with :code:`Then` will usually check to see if some condition is true. The 
conjunction :code:`And` allows more complicated versions of :code:`Given`, :code:`When`, or :code:`Then` phrases. The only other keyword you see in this 
format is :code:`But`.

A separate set of files defines the Ruby code that tests these steps. These are called
*step definitions*. How does Cucumber match each step of a scenario with the correct step
definitions? The trick is that Cucumber uses regular expressions or **regexes** (Chapter 2) to
match the phrases in the scenario steps to the step definitions themselves. For example, below
is a string from a step definition in the scenario for RottenPotatoes:

.. code-block:: cucumber

    Given /^(?:|I )am on (.+)$/


This regex can match the text “I am on the RottenPotatoes home page” on line 6 of Figure 7.4. The regex also 
captures the string after the phrase “am on ” until the end of the line (“the RottenPotatoes home page”). The 
body of the step definition contains Ruby code that tests the step, likely using captured strings such as the 
one above. Thus, most step definitions are typically used by many different steps. You can think of step definitions 
as method definitions, and the steps of the scenarios are analogous to method calls.

We then need a tool that will act as a user and pretend to use the feature under different scenarios. In the Rails 
world, this tool is called *Capybara*, and Cucumber integrates seamlessly with it. Capybara “pretends to be a user” 
by taking actions in a simulated web browser, for example, clicking on a link or button. Capybara can interact with 
the app to receive pages, parse the HTML, and submit forms as a user would. In the rest of this chapter and its 
associated CHIPS, you will write your own steps to describe the app’s behavior, then connect the steps to step 
definitions that actually stimulate the app to instantiate the behaviors—the core of Behavior-Driven Design.

Finally, the simple scenario above only describes one particular **happy path** of the feature in question, but it 
is also important to agree with the customer on what should happen when things go wrong. For example, if the user 
leaves the movie title blank, we would probably want to redisplay the Create New Movie page, but perhaps with an 
error message informing the user of what went wrong. This “sad path” would get its own scenario in the feature file 
and its own storyboard, since describing what happens when things go wrong is part of the overall feature.

**Self-Check 7.6.1.** *Given that Cucumber step definitions are just Ruby code, in principle we could just write the entire 
scenario in Ruby, rather than writing steps in stilted English and looking up the step definition for each step. Why do 
you think Cucumber has remained popular despite this fact?*

    The customer can (probably) read the Cucumber scenario steps and understand the description of what the app is supposed 
    to do, and can determine whether they agree with that description. Most customers would find it much more difficult to 
    read Ruby code. Thus the scenarios provide a common ground on which the technical team and customer can meet.