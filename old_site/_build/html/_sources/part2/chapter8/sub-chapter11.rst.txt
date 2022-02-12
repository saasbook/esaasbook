Fallacies and Pitfalls
====================================
**Fallacy: 100% test coverage with all tests passing means no bugs.**

There are many reasons this statement can be false. Complete test coverage says 
nothing about the quality of the individual tests. As well, some bugs may require 
passing a certain value as a method argument (for example, to trigger a divide-by-zero 
error), and control flow testing often cannot reveal such a bug. There may be bugs 
in the interaction between your app and an external service such as TMDb; stubbing 
out the service so you can perform local testing might mask such bugs.

**Pitfall: Dogmatically insisting on 100% test coverage all passing (green) before you ship.**

As we saw above, 100% test coverage is not only difficult to achieve at levels higher than C1, 
but gives no guarantees of bug-freedom even if you do achieve it. Test coverage is a useful 
tool for estimating the overall comprehensiveness of your test suite, but high confidence 
requires a variety of testing methods—integration as well as unit, fuzzing as well as 
hand-constructing test cases, define-use coverage as well as control-flow coverage, mutation 
testing to expose additional holes in the test strategy, and so on. Indeed, in Chapter 12 
we will discuss operational issues such as security and performance, which call for additional 
testing strategies beyond the correctness-oriented ones described in this chapter.

**Fallacy: You don’t need much test code to be confident in the application.**

While insisting on 100% coverage may be counterproductive, so is going to the other extreme. 
The *code-to-test ratio* in production systems (lines of noncomment code divided by lines of 
tests of all types) is usually less than 1, that is, there are more lines of test than lines 
of app code. As an extreme example, the SQLite database included with Rails contains over 
1200 times as much test code as application code because of the wide variety of ways in 
which it can be used and the wide variety of different kinds of systems on which it must 
work properly! While there is controversy over how useful a measure the code-to-test ratio 
is, given the high productivity of Ruby and its superior facilities for DRYing out your 
test code, a :code:`rake stats` ratio between 0.2 and 0.5 is a reasonable target.

**Pitfall: Relying too heavily on just one kind of test (unit, functional, integration).**

Unit and functional tests are useful for covering rare corner cases and code paths. They 
also tell you how well-factored or modular your code is: a module or method that is easy 
to test has well-circumscribed external dependencies, which in turn reinforces that it can 
be well tested in isolation. On the other hand, because of that very isolation, even 100% unit 
test coverage tells you nothing about interactions *among* classes or modules. That’s where 
integration-level tests such as the Cucumber scenarios of Chapter 7 are useful. Such tests 
touch only a tiny fraction of all possible application paths and exercise only a few behaviors 
in each method, but they do test the interfaces and interactions among modules. One rule of 
thumb used at Google and elsewhere (Whittaker et al. 2012) is “70–20–10”: 70% short and focused 
unit tests, 20% functional tests that touch multiple classes, 10% full-stack or integration 
tests. See Chapter 7 for the complementary pitfall of over-reliance on integration tests.

**Pitfall: Undertested integration points due to over-stubbing.**

Mocking and stubbing confer many benefits, but they can also hide potential problems at 
integration points—places where one class or module interacts with another. Suppose :code:`Movie` 
has some interactions with another class :code:`Moviegoer`, but for the purposes of unit testing :code:`Movie`, 
all calls to :code:`Moviegoer` methods are stubbed out, and vice versa. Because stubs are written to 
“fake” the behavior of the collaborating class(es), we no longer know if :code:`Movie` “knows how to 
talk to” :code:`Moviegoer` correctly. Good coverage with functional and integration tests, which don’t 
stub out all calls across class boundaries, avoids this pitfall.

**Pitfall: Writing tests after the code rather than before.**

Thinking about “the code we wish we had” from the perspective of a test for that code 
tends to result in code that is testable. This seems like an obvious tautology until you 
try writing the code first without testability in mind, only to discover that surprisingly 
often you end up with mock trainwrecks (see next pitfall) when you do try to write the test.

In addition, in the traditional Waterfall lifecycle described in Chapter 1, testing comes after 
code development, but with SaaS that can be in “public beta” for months, no one would suggest 
that testing should only begin after the beta period. Writing the tests first, whether for 
fixing bugs or creating new features, eliminates this pitfall.

**Pitfall: Mock Trainwrecks.**

Mocks exist to help isolate your tests from their collaborators, but what about the collaborators’ 
collaborators? Suppose our :code:`Movie` object has a :code:`pics` attribute that returns a list
of images associated with the movie, each of which is a Picture object that has a format
attribute. You’re trying to mock a Movie object for use in a test, but you realize that the
method to which you’re passing the Movie object is going to expect to call methods on its
pics, so you find yourself doing something like this:

.. code-block:: ruby

    movie = double('Movie', :pics => [double('Picture', :format => 'gif')]) 
    expect(Movie.count_pics(movie)).to eq 1

This is called a *mock trainwreck*, and it’s a sign that the method under test (:code:`count_pics`) has 
excessive knowledge of the innards of a :code:`Picture`. In Chapters 9 and 11 we’ll encounter a set of 
additional guidelines to help you detect and resolve such **code smells**.

**Pitfall: Inadvertently creating dependencies regarding the order in which specs are run, for 
example by using** :code:`before(:all)` **.**

If you specify actions to be performed only once for a whole group of test cases, you may 
introduce dependencies among those test cases without noticing. For example, if a :code:`before :all` 
block sets a variable and test example A changes the variable’s value, test example B could 
come to rely on that change if A is usually run before B. Then B’s behav- ior in the future 
might suddenly be different if B is run first, which might happen because guard prioritizes 
running tests related to recently-changed code. Therefore it’s best to use 
:code:`before :each` and :code:`after :each` whenever possible.

**Pitfall: Forgetting to re-prep the test database when the schema changes.**

Remember that tests run against a separate copy of the database, not the database used
in development (Section 4.2). Therefore, whenever you modify the schema by applying a 
migration, you must also run :code:`rake db:test:prepare` to apply those changes to the test 
database; otherwise your tests may fail because the test code doesn’t match the schema.