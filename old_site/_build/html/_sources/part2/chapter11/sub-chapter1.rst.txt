Patterns, Antipatterns, and SOLID Class Architecture
=====================================================
In Chapter 3, we introduced the idea of a design pattern: a reusable structure, 
behavior, strategy, or technique that captures a proven solution to a collection 
of similar problems by *separating the things that change from those that stay the 
same*. Patterns play a major role in helping us achieve our goal throughout this 
book: producing code that is not only correct (TDD) and meets a customer need (BDD), 
but is also concise, readable, DRY, and generally beautiful. Figure 11.1 highlights 
the role of design patterns in the Agile lifecycle as covered in this chapter.

While we have already seen architectural patterns such as Client–Server and structural 
patterns such as Model–View–Controller, this chapter examines design patterns that apply 
to classes and class architecture. As Figure 11.2 shows, we will follow a similar approach 
as we did in Chapter 9. Rather than simply listing a catalog of design patterns, we’ll 
motivate their use by starting from some guidelines about what makes a class architecture 
good or bad, identifying smells and metrics that indicate possible problem spots, and 
showing how some of these problems can be fixed by refactoring—both within classes and by 
moving code across classes—to eliminate the problems. In some cases, we can refactor to make 
the code match an existing and proven design pattern. In other cases, the refactoring doesn’t 
necessarily result in major structural changes to the class architecture.

As with method-level refactoring, application of design patterns is best learned by doing, and 
the number of design patterns exceeds what we can cover in one chapter of one book. Indeed, 
there are entire books just on design patterns, including the seminal *Design Patterns: Elements 
of Reusable Object-Oriented Software* (Gamma et al. 1994), whose authors became known as the 
“Gang of Four” or GoF, and their catalog known as the “**GoF design patterns.**” The 23 GoF 
design patterns are divided into Creational, Structural, and Behavioral design patterns, as 
Figure 11.3 shows. As with Fowler’s original book on refactoring, the GoF design patterns 
book gave rise to other books with examples tailored to specific languages including Ruby 
(Olsen 2007).

The GoF authors cite two overarching principles of good object-oriented design that in-
form most of the patterns:

• Prefer Composition and Delegation over Inheritance. 
• Program to an Interface, not an Implementation.

We will learn what these catch-phrases mean as we explore some specific design patterns.

In an ideal world, all programmers would use design patterns tastefully, continuously 
refactoring their code as Chapter 9 suggests, and all code would be beautiful. Needless 
to say, this is not always the case. An *antipattern* is a piece of code that seems to want 
to be expressed in terms of a well-known design pattern, but isn’t—often because the 
original (good) code has evolved to fill new needs without refactoring along the way. 
*Design smells*, similar to the code smells we saw in Chapter 9, are warning signs that 
your code may be headed towards an antipattern. In contrast to code smells, which typically 
apply to methods within a class, design smells apply to relationships between classes and 
how responsibilities are divided among them. Therefore, whereas refactoring a method involves 
moving code around *within* a class, refactoring a design involves moving code *between* classes, 
creating new classes or modules (perhaps by extracting commonality from existing ones), or 
removing classes that aren’t pulling their weight.

Similar to SOFA in Chapter 9, the mnemonic SOLID (credited to Robert C. Martin)
stands for a set of five design principles that clean code should respect. As in Chapter 9, 
design smells and quantitative metrics can tell us when we’re in danger of violating one or 
more SOLID guidelines; the fix is often a refactoring that eliminates the problem by bringing 
the code in line with one or more design patterns.

Figure 11.4 shows the SOLID mnemonics and what they tell us about good composition of classes. 
In our discussion of selected design patterns, we’ll see violations of each one of these 
guidelines, and show how refactoring the bad code (in some cases, with the goal of applying a 
design pattern) can fix the violation. In general, the SOLID principles strive for a class 
architecture that avoids various problems that thwart productivity:

1. Viscosity: it’s easier to fix a problem using a quick hack, even though you know that’s not the right thing to do.
2. Immobility: it’s hard to be DRY and because the functionality you want to reuse is wired into the app in a way that makes extraction difficult.
3. Needless repetition: possibly as a consequence of immobility, the app has similar func- tionality duplicated in multiple places. As a result, a change in one part of the app often ripples to many other parts of the app, so that a small change in functionality requires a lot of little changes to code and tests, a process sometimes called *shotgun surgery*.
4. Needless complexity: the app’s design reflects generality that was inserted before it was needed.

As with refactoring and legacy code, seeking out design smells and addressing them by refactoring 
with judicious use of design patterns is a skill learned by doing. Therefore, rather than 
presenting “laundry lists” of design smells, refactorings, and design patterns, we focus our 
discussion around the SOLID principles and give a few representative examples of the overall 
process of identifying design smells and assessing the alternatives for addressing
them. As you tackle your own applications, perusing the more detailed resources listed 
in Section 11.10 is essential.

**Self-Check 11.1.1.** *True or false: one measure of the quality of a piece of software is 
the degree to which it uses design patterns.*

    False: while design patterns provide proven solutions to some common problems, code that 
    doesn’t exhibit such problems may not need those patterns, but that doesn’t make it poor 
    code. The GoF authors specifically warn against measuring code quality in terms of design 
    pattern usage.