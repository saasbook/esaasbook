The Plan-And-Document Perspective on Design Patterns
=====================================================

A strength of Plan-and-Document is that careful upfront planning can result in a 
product with a good software architecture that uses design patterns well. This 
preplanning is reflected in the alternative catch phrase for these processes of **Big 
Design Up Front**, as Chapter 1 mentions.

A Plan-and-Document development team starts with the **Software Requirements Specification (SRS)** 
(see Section 7.9), which the team breaks into a series of problems. For each one, the team 
looks for one or more architecture patterns that might solve the prob- lem. The team then goes 
down to the next level of subproblems, and looks for design patterns that match them. The 
philosophy is to learn from the experience of others captured as patterns so as to avoid 
repeating the mistakes of your predecessors. Another way to get feedback from more experienced 
engineers is to hold a **design review** (see Section 10.7). Note that design reviews can be done 
before any code is written in Plan-and-Document processes.

Thus, compared to Agile, there is considerably more effort in starting with a good design 
in Plan-and-Document. As Martin Fowler points out in his article *Is Design Dead?*, a 
frequent critique of Agile is that it encourages developers to jump in and start coding 
without any design, and rely too much on refactoring to fix things later. As the critics 
sometimes say, you can build a doghouse by slapping stuff together and planning as you go, 
but you can’t build a skyscraper that way.

Agile supporters counter that Plan-and-Document methods are just as bad: by disallowing any 
code until the design is complete, it’s impossible to be confident that the design will be 
implementable or that it really captures the customer’s needs. This critique especially holds 
when the architects/designers will not be writing the code or may be out of touch with current 
coding practices and tools. As a result, say Agile proponents, when coding starts, the design 
will have to change anyway.

Both sides have a point, but the critique can be phrased in a more nuanced way as “How much 
design makes sense up front?” For example, Agile developers plan for persistent storage as part 
of their SaaS apps, even though the first BDD and TDD tests they write will not touch the 
database. A more subtle example is horizontal scaling. As we alluded to in Chapter 3, and will 
discuss more fully in Chapter 12, designers of successful SaaS *must* think about horizontal 
scalability early on. Even though it may be months before scalability matters, design decisions 
early in the project can cripple scalability, and it may be difficult to change them without 
major rewriting and refactoring.

A possible solution to the conundrum is captured by a rule of thumb in Fowler’s article. If you 
have previously done a project that has some design constraint or element, it’s OK to plan for 
it in a new project that is similar, because your previous experience will likely lead to 
reasonable design decisions this time.

**Self-Check 11.8.1.** *True or False: Agile design is an oxymoron.*

    False. Although there is no separate design phase in Agile development, the refactoring 
    that is the norm in Agile can incorporate design patterns.