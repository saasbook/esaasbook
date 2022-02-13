Software Quality Assurance: Testing 
====================================
*And the users exclaimed with a laugh and a taunt: “It’s just what we asked for, 
but not what we want.”*
    —Anonymous

A standard definition of **quality** for any product is “fitness for use,” which must 
provide business value for both the customer and the manufacturer (Juran and Gryna 1998). 
For software, quality means both satisfying the customer’s needs—easy to use, gets correct 
answers, does not crash, and so on—*and* being easy for the developer to debug and enhance. **Quality 
Assurance (QA)** also comes from manufacturing, and refers to processes and standards that lead 
to manufacture of high-quality products and to the introduction of manufacturing processes that 
improve quality. Software QA, then, means both ensuring that products under development have high 
quality and creating processes and standards in an organization that lead to high quality software. 
As we shall see, some Plan-and-Document software processes even use a separate QA team that tests 
software quality (Section 8.10).

Determining software quality involves two terms that are commonly interchanged but have subtle distinctions (Boehm 1979):

**• Verification**: Did you build the thing *right*? (Did you meet the specification?)

**• Validation**: Did you build the right *thing*? (Is this what the customer wants? That is, is the specification correct?)

Software prototypes that are the lifeblood of Agile typically help with validation rather than verification, since customers 
often change their minds on what they want once they begin to see the product work.

The main approach to verification and validation is **testing**; the motivation for testing is that the earlier developers 
find mistakes, the cheaper it is to repair them. Given the vast number of different combinations of inputs, testing 
cannot be exhaustive. One way to reduce the space is to perform different tests at different phases of software development. 
Starting bottom up, **unit testing** makes sure that a single procedure or method does what was expected. The next level up 
is *module testing*, which tests across individual units. For example, unit testing works within a single class whereas module 
testing works across classes. Above this level is **integration testing**, which ensures that the interfaces between the units have 
consistent assumptions and communicate correctly. This level does not test the functionality of the units. At the top level is 
**system testing** or **acceptance testing**, which tests to see if the integrated program meets its specifications. In Chapter 8, we’ll 
describe an alternative to testing, called **formal methods**.

As mentioned briefly in Section 1.3, the approach to testing for the XP version of Agile is to write the tests *before* you write the 
code. You then write the minimum code you need to pass the test, which ensures that your code is always tested and reduces the chances 
of writing code that will be later discarded. XP splits this test-first philosophy into two parts, depending on the level of the testing. 
For system, acceptance, and integration tests, XP uses *Behavior-Driven Design (BDD)*, which is the topic of Chapter 7. For unit and module 
tests, XP uses *Test-Driven Development (TDD)*, which is the topic of Chapter 8.

**Self-Check 1.4.1.** *While all of the following help with verification, which form of testing is most likely to help with validation: 
Unit, Module, Integration, or Acceptance?*

    Validation is concerned with doing what the customer really wants versus whether code met the specification, so acceptance testing is most 
    likely to point out the difference between doing the thing right and doing the right thing.
