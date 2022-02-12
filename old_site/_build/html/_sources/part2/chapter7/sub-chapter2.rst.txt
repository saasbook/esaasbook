SMART User Stories 
====================================

What makes a good user story versus a bad one? The SMART acronym offers concrete and (hopefully) memorable 
guidelines: Specific, Measurable, Achievable, Relevant, and Timeboxed.

• *Specific*. Here are examples of a vague feature paired with a specific version:

.. code-block:: cucumber

    Feature: User can search for a movie (vague)
    Feature: User can search for a movie by title (specific)

• *Measurable*. Adding Measurable to Specific means that each story should be testable, which implies that there are known expected results for some good inputs. An example of a pair of an unmeasurable versus measurable feature is

.. code-block:: cucumber

    Feature: RottenPotatoes should have good response time (unmeasurable)
    Feature: When adding a movie, 99% of Add Movie pages
             should appear within 3 seconds (measurable)

Only the second case can be tested to see if the system fulfills the requirement.

• *Achievable*. Ideally, you implement the user story in one Agile iteration. If you are getting less than one story per iteration, then they are too big and you need to subdi- vide these stories into smaller ones. As mentioned above, the tool **Pivotal Tracker** measures Velocity, which is the rate of completing stories of varying difficulty.
• *Relevant*. A user story must have business value to one or more stakeholders. To drill down to the real business value, one technique is to keep asking “Why.” Using as an example a ticket-selling app for a regional theater, suppose the proposal is to add a Facebook linking feature. Here are the “Five Whys” in action with their recursive questions and answers:

1. Why add the Facebook feature? As box office manager, I think more people will go with friends and enjoy the show more.
2. Why does it matter if they enjoy the show more? I think we will sell more tickets.
3. Why do you want to sell more tickets? Because then the theater makes more money.
4. Why does theater want to make more money? We want to make more money so that we don’t go out of business.
5. Why does it matter that theater is in business next year? If not, I have no job.

(We’re pretty sure the business value is now apparent to at least one stakeholder!)

• *Timeboxed*. Timeboxing means that you stop developing a story once you’ve exceeded the time budget. Either you give up, divide the user story into smaller ones, or reschedule what is left according to a new estimate. If dividing looks like it won’t help, then you go back to the customers to find the highest value part of the story that you can do quickly. The reason for a time budget per user story is that it is extremely easy to underestimate the length of a software project. Without careful accounting of each iteration, the whole project could be late, and thus fail. Learning to budget a software project is a critical skill, and exceeding a story budget and then refactoring it is one way to acquire that skill.

One important concept expands upon the R of SMART. The **minimum viable product** (MVP) is a subset of the full set of features 
that when completed has business value in the real world. Not only are the stories Relevant, but the combination of all of 
them makes the software product viable in the marketplace. Obviously, you can’t start selling the product if it’s not 
viable, so it makes sense to give priority to the stories that will let the product be shipped. The Epic or a Release point 
of Pivotal Tracker can help identify the stories of the MVP.

**Self-Check 7.2.1.** *Which SMART guideline(s) does the feature below 
violate?*

.. code-block:: cucumber

    Feature: RottenPotatoes should have a good User Interface

\

    It is not Specific, not Measurable, not Achievable (within 1 iteration), and not Timeboxed. 
    While business Relevant, this feature goes just one for five.

**Self-Check 7.2.2.** *Rewrite this feature to make it 
SMART.*

.. code-block:: cucumber
    
    Feature: I want to see a sorted list of movies sold.

\

    Here is one SMART revision of this user story:

    .. code-block:: cucumber

        Feature: As a customer, I want to see the top 10 movies sold,
                listed by price, so that I can buy the cheapest ones 
                first.

Given user stories as the work product from eliciting requirements of customers, we can introduce a metric and tool to measure productivity.
