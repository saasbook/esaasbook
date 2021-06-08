Fallacies and Pitfalls
====================================

**Pitfall: Customers who confuse mock-ups with completed features.**

As a developer, this pitfall may seem ridiculous to you. But nontechnical customers sometimes have 
difficulty distinguishing a highly polished digital mock-up from a working feature! The solution is 
simple: use paper-and-pencil techniques such as hand-drawn sketches and storyboards to reach agreement 
with the customer—there can be no doubt that such Lo-Fi mockups represent *proposed* rather than implemented 
functionality.

**Pitfall: Adding cool features that do not make the product more successful.**

Agile development was inspired in part by the frustration of software developers building what they 
thought was cool code that customers dropped. The temptation is strong to add a feature that you think 
would be great, but it can also be disappointing when your work is discarded. User stories help all stakeholders 
prioritize development and reduce chances of wasted effort on features that only developers love.

**Pitfall: Sketches without storyboards.**

Sketches are static; interactions with a SaaS app occur as a sequence of actions over time. You and the customer 
must agree not only on the general content of the Lo-Fi UI sketches, but on what happens when they interact with 
the page. “Animating” the Lo-Fi sketches—“OK, you clicked on that button, here’s what you see; is that what you 
expected?”—goes a long way towards ironing out misunderstandings *before* the stories are turned into tests and code.

**Pitfall: Tracking tasks rather than stories.**

A story is the customer’s view of how a feature should work, such as “Box office manager can generate a report of 
today’s sales.” Tasks such as “Add Excel export code in Report model” is a developer-facing task that, while it may 
be part of implementing a story, is not itself something that results in customer value. Use project management and 
effort estimation tools to track stories, not tasks. Tracker allows multiple specific tasks to be part of a story, 
but expressing the task itself as a story also entails the further risk that you’ll use the tool as a to-do list, 
simply checking off tasks when they’re done, rather than tracking the lifecycle of a story and allowing you to improve 
your skill at estimating project effort.

**Pitfall: Using Cucumber solely as a test-automation tool rather than as a common middle ground for all stakeholders.**

If you look at :code:`web_steps.rb`, you’ll quickly notice that low-level, imperative Cucumber steps such as “When I press Cancel” 
are merely a thin wrapper around Capybara’s “headless browser” API, and you might wonder (as some of the authors’ students 
have) why you should use Cucumber at all. But Cucumber’s real value is in creating documentation that nontechnical 
stakeholders and developers can agree on *and* that serves as the basis for automating acceptance and integration tests, 
which is why the Cucumber features and steps for a mature app should evolve towards a “mini-language” appropriate for 
that app. For example, an app for scheduling vacations for hospital nurses would have scenarios that make heavy use of 
domain-specific terms such as *shift, seniority, holiday, overtime*, and so on, rather than focusing on the low-level 
interactions between the user and each view.

**Pitfall: Relying too heavily on integration-level scenarios for your tests.**

Scenarios are comforting to write and satisfying to run (when they pass) because they closely mimic what a real user 
would do. Indeed, that is why Cucumber tests have value both as validation—you built the right thing, because the test 
instantiates a user story cre- ated in collaboration with the customer—and verification—you built the thing right, 
because the test passes. However, one thing such tests *don’t* reveal is whether your code is well factored—whether the 
different subsystems exercised in the scenario are easily testable, let alone whether each has been thoroughly tested. 
Unit and module level tests, which are the subject of Chapter 8, are more likely to tell you about the design of your 
code. Of course, over-reliance on unit and module level tests is just as bad, as the corresponding Pitfall at the
end of Chapter 8 reminds us!

**Fallacy: The feature is “done” if it works correctly in production, even if the scenario doesn’t pass.**

When a test fails, it’s trying to tell you something. Sometimes it’s straightforward— there’s a bug in your code. 
Other times it’s more subtle: your code fulfills the requirements of the user story, but for some reason, it is 
unusually difficult to test. Either way, the outcome bears investigation. Without an integration test you can trust, 
it will be hard to detect if future changes cause your existing code to break.

**Pitfall: Trying to predict what you need before you need it.**

Part of the magic of Behavior-Driven Design (and Test-Driven Development in the next chapter) is that you write the 
tests *before* you write the code you need, and then you write code needed to pass the tests. This top-down approach 
again makes it more likely for your efforts to be useful, which is harder to do when you’re predicting what you think 
you’ll need. This observation has also been called the YAGNI principle—You Ain’t Gonna Need It.

**Pitfall: Careless use of negative expectations.**

*Beware of overusing Then I should not see...*. Because it tests a negative condition, you might not be able to tell 
if the output is what you intended—you canonly tell what the output *isn’t*. Many, many outputs don’t match, so that 
is not likely to be a good test. For example, if you were testing for the *absence* of “Welcome, Dave!” but you accidentally 
wrote :code:`Then I should not see “Greetings, Dave!”`, the scenario will pass even if the app incorrectly emits “Welcome, Dave!”. Always 
include positive expectations such as *Then I should see...* to check results.

**Pitfall: Careless use of positive expectations.**

Even if you use positive expectations such as *Then I should see...*, what if the string you’re looking for occurs 
multiple times on the page? For example, if the logged-in user’s name is Emma and your scenario is checking whether 
Jane Austen’s book *Emma* was correctly added to the shopping cart, a scenario step *Then I should see “Emma”* might 
pass even if the cart isn’t working. To avoid this pitfall, use Capybara’s :code:`within` helper, which constrains the scope 
of matchers such as *I should see* to the element(s) matching a given CSS selector, as in :code:`Then I should see ”Emma” within 
”div#shopping_cart”`, and use unambiguous HTML :code:`id` or :code:`class` attributes for page elements you want to name in your scenarios. 
The Capybara documentation lists all the matchers and helpers.

**Pitfall: Delivering a story as “done” when only the happy path is tested.**

As should be clear by now, a story is only a candidate for delivery when both the happy path and the most important sad paths have been tested. Of course, as 
Chapter 8 describes, there are many more ways for something to work incorrectly than to work correctly, and sad-path tests 
are not intended to be a substitute for finer-grained test coverage. But from the user’s point of view, correct app behavior 
when the user accidentally does the wrong thing is just as important as correct behavior when they do the right thing.
