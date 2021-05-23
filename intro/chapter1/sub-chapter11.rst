Fallacies and Pitfalls
====================================
*Lord, give us the wisdom to utter words that are gentle and tender, for tomorrow we may 
have to eat them.*
    —Sen. Morris Udall

As mentioned above, this section near the end of a chapter explains ideas of a chapter 
from another perspective, and gives readers a chance to learn from the mistakes of others. 
*Fallacies* are statements that seem plausible (or are actually widely held views) based on 
the ideas in the chapter, but they are not true. *Pitfalls*, on the other hand, are common 
dangers associated with the topics in the chapter that are difficult to avoid even when 
you are warned.

    **Fallacy: The Agile lifecycle is best for all software development.**

Agile is a nice match to many types of software, particularly SaaS, which is why we use it 
in this book. However, Agile is *not* best for everything. Agile may be ineffective for 
safety-critical apps, for example.

Our experience is that once you learn the classic steps of software development and have 
a positive experience in using them via Agile, you will use these important software 
engineering principles in other projects no matter which methodology is used. Each 
chapter in Part II concludes with contrasting Plan-and-Document perspective to help you 
understand these principles and to help you use other lifecycles should the need arise.

Nor will Agile be the last software lifecycle you will ever see. We believe that new development 
methodologies develop and become popular in response to new opportunities, so expect to learn 
new methodologies and frameworks in your future.

    **Pitfall: Ignoring the cost of software design.**

Since there is essentially no cost to distribute software, the temptation is to believe there is 
almost no cost to changing it so that it can be “remanufactured” the way the customer wants. 
However, this perspective ignores the cost of design and test, which can be a substantial part 
of the overall costs for software projects. Zero manufacturing cost is also one rationalization 
used to justify pirating copies of software and other electronic data, since pirates apparently 
believe no one should pay for the cost of development, just for manufacturing.

    **Pitfall: Ignoring the historical context of software technology.**

*Those who cannot remember the past are condemned to repeat it.*

    —George Santayana

Software engineering is a relatively young engineering field, but a fast-moving one. If you try to 
learn software technologies while ignoring the historical context in which they arose,
you risk making underinformed choices about what tools to use, or worse, “reinventing the wheel” 
without learning from the experiences of others. For example, if you’re debating with colleagues 
about the advisability of using Node.js as your application server, but you are unfamiliar with the 
long-running “threads vs. events” debates in the systems software community, at best you will be 
having an under-informed discussion, and at worst you will be quickly beset by woe. Similarly, the 
feature creep of “NoSQL” databases mirrors the progression of events that led to the invention of 
the **relational model** and its eventual dom- inance over the older **hierarchical database model**, which 
“baseline” NoSQL databases strongly resemble. Reinventing the wheel isn’t always necessarily a bad 
thing. Sometimes the existing wheel really isn’t a great fit for your needs—as Douglas Crockford is 
said to have remarked, “The good thing about reinventing the wheel is that you can get a round one.” 
Our hope is that learners of this material will choose to take a few extra minutes to gain a broader
perspective on *why* various things are the way they are (or not). We believe this will not only help 
you decide whether a particular wheel reinvention is a good one, but also help you avoid techno-fetishism—the 
belief that a new “rockstar” technology is important and worth learning simply because it’s new (or fast, 
or lean, or whatever), without a well-grounded per- spective of its strengths and weaknesses or of how 
it builds on ideas that have been explored previously.

    **Pitfall: Being overly focused on learning framework X as rapidly as possible.**

Possible values of X change so quickly that in any given leap year, the “new hot tech” for building software 
is probably different from what it was during the previous leap year. Indeed, since the first edition of 
this book in 2013, “hot tech” for building front-end apps has changed from Prototype.js to jQuery to Angular 
to Ember to Backbone to React, with Vue now another contender. Therefore, your authors believe that it’s 
more valuable to *learn how to learn* new languages and frameworks, by understanding the fundamental principles 
of software architecture and design on which they’re built, by continuously acquiring fluency in multiple 
frameworks and tools, and by adopting an ecumenical approach to the question of “which language or framework 
is best” for a given project.



