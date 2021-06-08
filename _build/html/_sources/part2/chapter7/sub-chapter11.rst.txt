Concluding Remarks: Pros and Cons of BDD 
====================================
    In software, we rarely have meaningful requirements. Even if we do, the only measure of success 
    that matters is whether our solution solves the customer’s shifting idea of what their problem is.

    —Jeff Atwood, Is Software Development Like Manufacturing?, 2006

Figure 7.9 shows the relationship of the testing tools introduced in this chapter to the testing tools in 
the following chapters. Cucumber allows writing user stories as features, scenarios, and steps and matches 
these steps to step definitions using regular expressions. The step definitions invoke methods in Cucumber 
and Capybara. We need Capybara because we are writing a SaaS application, and testing requires a tool to act 
as the user and web browser. If the app was not for SaaS, then we could invoke the methods that test the app 
directly in Cucumber.

The advantage of user stories and BDD is creating a common language shared by all stakeholders, especially the 
nontechnical customers. BDD is perfect for projects where the requirements are poorly understood or rapidly 
changing, which is often the case. User stories also make it easy to break projects into small increments or 
iterations, which makes it easier
to estimate how much work remains. The use of 3x5 cards and paper mockups of user interfaces keeps the nontechnical 
customers involved in the design and prioritization of features, which increases the chances of the software meeting 
the customer’s needs. Iterations drive the refinement of this software development process. Moreover, BDD and Cucumber 
naturally leads to writing tests *before* coding, shifting the validation and development effort from debugging to testing.

Comparing user stories, Cucumber, points, and velocity to the plan-and-document processes makes it clear that BDD plays 
many important roles in the Agile process:

1. Requirement elicitation
2. Requirement documentation
3. Acceptance tests
4. Traceability between features and implementation 
5. Scheduling and monitoring of project progress

The downside of user stories and BDD is that it may be difficult or too expensive to have continuous contact with 
the customer throughout the development process, as some customers may not want to participate. This approach may 
also not scale to very large software development projects or to safety critical applications. Perhaps plan-and-document 
is a better match in both situations.

Another potential downside of BDD is that the project could satisfy customers but not result in a good software 
architecture, which is an important foundation for maintaining the code. Chapter 11 discusses design patterns, which 
should be part of your software development toolkit. Recognizing which pattern matches the circumstances and 
refactoring code when necessary (see Chapter 9) reduces the chances of BDD producing poor software architectures.

All this being said, there is enormous momentum in the Ruby community (which places high value on testable, beautiful 
and self-documenting code) to document and promote best practices for specifying behavior both as a way to document 
the intent of the app’s developers and to provide executable acceptance tests. The Cucumber wiki is a good place to start.

BDD may not seem initially the natural way to develop software; the strong temptation is to just start hacking code. 
However, once you have learned BDD and had success at it, for most developers there is no going back. Your authors remind 
you that good tools, while sometimes intimidating to learn, repay the effort many times over in the long run. Whenever 
possible in the future, we believe you’ll follow the BDD path to writing beautiful code.

You may find the following resources useful for more depth on the topics in this chapter:

• Want to see paper prototyping and storyboards in action? First read this excellent article with examples of paper prototyping, then watch this video of paper storyboarding for a web-based email app.
• The Cucumber wiki has links to documentation, tutorials, examples, screencasts, best practices, and lots more on Cucumber.
• *The Cucumber Book* (Wynne and Hellesøy 2012), co-authored by the tool’s creator and one of its earliest adopters, includes detailed information and examples using Cucum- ber, excellent discussions of best practices for BDD, and additional Cucumber uses such as testing RESTful service automation.
• Ben Mabey (a core Cucumber developer) and Jonas Nicklas, among others, have written eloquently about the benefits of declarative vs. imperative Cucumber scenarios. In fact, the main author of Cucumber, Aslak Hellesøy, deliberately removed :code:`web_steps.rb` from Cucumber in October 2011, which is why we had to separately install the :code:`cucumber_rails_training_wheels` gem to get it for our examples.

