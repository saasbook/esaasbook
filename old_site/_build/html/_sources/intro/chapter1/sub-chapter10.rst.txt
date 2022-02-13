Guided Tour and How To Use This Book
====================================
As this chapter’s Concepts and Prerequisites described, becoming a skilled 
software engineer requires *both* conceptual understanding and plenty of hands-on 
practice. Therefore, our goal in each chapter is to give you the necessary conceptual 
foundations to work on the exercises, where the real learning happens.

The rest of the book is divided into two parts. Part I explains Software as a Service, 
and Part II explains modern software development, with a heavy emphasis on Agile.

Chapter 3 starts Part I with an explanation of the architecture of a SaaS application, 
and how the Web went from a collection of static pages to an ecosystem of services 
characterized by RESTful APIs—that is, Application Programming Interfaces based on the 
design stance of REpresentational State Transfer.

Since languages and frameworks evolve rapidly, we believe *learning how to learn* new 
languages and frameworks is a more valuable skill than knowing a specific language or 
framework. Thus, Chapter 2 introduces our methodology for doing so, using Ruby as an 
example, for programmers already familiar with another modern language such as Java or Python

Similarly, today the main reason for learning a new language is often the desire to use a 
framework that relies on that language. A good framework both reifies a particular application 
architecture and takes advantage of the features of a particular language to make
development easy when it conforms to that architecture. Chapter 4 introduces the basics 
of Rails and its central metaphor of the Model–View–Controller architecture. Chapter 5 covers 
more advanced Rails features and shows in more depth how Rails takes advantage of Ruby’s 
language features. Splitting the material this way allows for readers who want to get started 
writing an app as soon as they can, which just requires Chapter 4. While the material in 
Chapter 5 is more challenging to learn and understand, your application can be DRYer and more 
concise if you use concepts like partials, validations, lifecycle callbacks, filters, 
associations, and foreign keys. Readers already familiar with Ruby and Rails may want to 
skim or skip these chapters.

Building on the familiarity with Ruby and Rails by this point in the book, Chapter 6 introduces 
the programming language JavaScript, its productive framework jQuery, and the testing tool Jasmine. 
Just as the Rails framework amplifies the power and productivity of the Ruby language for creating 
the server side of SaaS apps, the jQuery framework amplifies the power and productivity of JavaScript 
for enhancing its client side. And just as RSpec makes it possible to write powerful automated tests 
to increase our confidence in our Ruby and Rails code, Jasmine makes it possible to write similar 
tests to increase our confidence in our JavaScript code.

Given this background, the next six chapters of Part II illustrate important software engineering 
principles using Rails tools to build and deploy a SaaS app. Figure 1.9 shows one iteration of the 
Agile lifecycle, which we use as a framework on which to hang the next chapters of the book.

Chapter 7 discusses how to talk to the customer. **Behavior-Driven Design (BDD)** advocates writing 
acceptance tests that customers without a programming background can understand, called **user stories**, 
and Chapter 7 shows how to write them so that they can be turned into integration tests as well. 
It introduces the **Cucumber** tool to help automate this task. This testing tool can be used with any 
language and framework, not just Rails. As SaaS apps are often user facing, the chapter also covers 
how to prototype a useful user interface using “Lo-Fi” prototyping. It also explains the term **Velocity** 
and how to use it to measure progress in the rate that you deliver features, and introduces the SaaS-based 
tool **Pivotal Tracker** to track and calculate such measurements.

Chapter 8 covers **Test-Driven Development (TDD)**. The chapter demonstrates how to write good, testable code 
and introduces the **RSpec** testing tool for writing unit tests, the *Guard* tool for automating test running, 
and the *SimpleCov* tool to measure test coverage.

Chapter 9 describes how to deal with existing code, including how to enhance legacy code. Helpfully, it shows 
how to use BDD and TDD to both understand and refactor code and how to use the Cucumber and RSpec tools to make 
this task easier.

Chapter 10 gives advice on how to organize and work as part of an effective team using the *Scrum* principles 
mentioned above. It also describes how the version control system **Git** and the corresponding service **GitHub** can 
let team members work on different features without interfering with each other or causing chaos in the release 
process.

To help you practice Don’t Repeat Yourself, Chapter 11 introduces design patterns, which are proven structural 
solutions to common problems in designing how classes work together, and shows how to exploit Ruby’s language 
features to adopt and reuse the patterns. The chapter also offers guidelines on how to write good classes. It 
introduces just enough *UML (Unified Modeling Language)* notation to help you notate design patterns and to help 
you make diagrams that show how the classes should work.

Note that Chapter 11 is about software architecture whereas prior chapters in Part II are
about the Agile development process. We believe in a college course setting that this order will let you start 
an Agile iteration sooner, and we think the more iterations you do, the better you will understand the Agile 
lifecycle. However, as Figure 1.9 suggests, knowing design patterns will be useful when writing or refactoring 
code, since it is fundamental to the BDD/TDD process.

Chapter 12 offers practical advice on how to first deploy and then improve performance and scalability in the 
cloud, and briefly introduces some reliability and security techniques that are uniquely relevant to deploying SaaS.

We conclude with an Afterword that reflects on the material in the book and projects what might be next.

**CHIPS**. As Confucius said: “I hear and I forget, I see and I remember, I do and I under- stand.” The goal of the 
book is to give you just enough content to get a conceptual handle on the Coding/Hands-On Integrated Projects 
(CHIPS) interspersed with the text. Each CHIPS exercise contains significant guidance and hints for the 
self-learning you’ll have to do to com- plete it. If you’re using this book in conjunction with online course 
materials from Codio, switching between the content-oriented didactic material (COD) and the coding/hands-on 
integrated projects (CHIPS) is especially easy, and your assignments will be automatically graded for you.

**Terminology**. You will encounter many new technical terms (and buzzwords) as you dive into this rich ecosystem. 
To help you identify important terms, text formatted **like this** refers to terms with corresponding Wikipedia 
entries. (In the Kindle book, PDF document, and Codio book, the terms link to the appropriate Wikipedia page.) 
Depending on your background, we suspect you’ll need to read some chapters more than once before you get the hang of it.

Each chapter concludes with a section called *Fallacies and Pitfalls*, which explains common misconceptions or 
problems that are easy to experience if you’re not vigilant, and Concluding Remarks to provide resources for 
those who want to dig more deeply into some of the chapter’s concepts.

**Self-Check 1.10.1.** *Which is most important for rapidly learning SaaS development: understanding the conceptual 
foundations, reading code, or writing code?*

    All are important. You won’t learn much by copying-and-pasting code if you don’t un- derstand why it works (or doesn’t). 
    On the other hand, just reading *about* code doesn’t get
    anything working. Inspecting others’ high-quality code, which we hope your instructors will emphasize, not only shows you 
    good examples but also helps cement your understanding of the conceptual foundations.




