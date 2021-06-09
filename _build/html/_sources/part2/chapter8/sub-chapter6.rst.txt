Fixtures and Factories
====================================

Doubles are appropriate when you need a stand-in with a small amount of 
functionality to isolate the code under test from its dependencies. But suppose 
you were testing a new instance method of class :code:`Movie` called :code:`name_with_rating` 
that returns a nicely formatted string
showing a movie’s title and rating. Clearly, such a method would have to access the :code:`title` 
and :code:`rating` attributes of a :code:`Movie` instance. You could create a double that knows all that
information, and pass that double:

.. code-block:: ruby

    fake_movie = double('Movie')
    allow(fake_movie).to receive(:title).and_return('Casablanca')
    allow(fake_movie).to receive(:rating).and_return('PG')
    expect(fake_movie.name_with_rating).to eq 'Casablanca (PG)'

But since the instance method being tested is part of the :code:`Movie` class itself, it makes sense
to use a real object here, since this isn’t a case of isolating the test code from collaborator classes.

Where can we get a real Movie instance to use in such a test? Most testing frameworks for 
object-oriented languages support the use of **factories**—bits of code (or declarative descriptions 
of objects) framework designed to allow quick creation of full-featured objects (rather than 
mocks) at testing time. The goal of a factory is to quickly create valid instances of a class 
using some default attributes that you can selectively override for testing. For example, if 
you were testing some code that allows a user to write a review for a movie, you might need a 
valid movie instance to pass to that code. In the above scenario of testing a title-and-rating 
formatter, you don’t care what the movie’s release date is, or who directed it; you just need a 
movie object that is valid and whose title and rating you do know. So you would ask the factory 
to produce a movie instance whose title and rating you specify, but whose other attributes you 
don’t care about as long as they are valid values.

You might think this seems like more work than just creating a movie instance directly by 
calling its constructor. In our simple example, that may be true. But there are two cases 
in which factories really shine. The first is when the object to be created has many attributes 
that must be initialized at creation time, even though any particular test case may only care 
about the specific values of a few of them. For example, the app that manipulaties :code:`Movie` objects 
may have validations requiring a movie to have a valid release date or other fields meeting 
specific criteria, yet the test above doesn’t care about the values of those other fields. In 
such cases, you can ask the factory to create an object in which certain attribute values are 
specified but others are filled in with valid defaults. The second case is when objects you 
need to create have has-many or belongs-to relationships with other objects, as Chapter 5 
describes. For example, if a Review belongs to a Movie, and you are creating a set of tests 
to check various behaviors of Reviews, you literally cannot create a valid Review instance 
without creating a Movie instance for it to belong to, even if the tests you are writing don’t 
care about the movie itself. In this case, the Review factory can be configured so that creating 
a Review also creates a valid Movie to which it belongs. Again, you can either specify a 
particular Movie object you’ve created, or let the factory create one with valid default 
values. Then in your test you can simply ask for a Review object to be created, without having 
the details of the parent relationship clutter your test code.

The Ruby gem FactoryBot lets you define a factory for any kind of model in your app and 
create just the objects you need quickly for each test, selectively overriding only certain 
attributes, as Figure 8.8 shows.

.. code-block:: ruby

    # spec/factories/movie.rb
    FactoryBot.define do 
        factory :movie do
            title 'A Fake Title' # default values 
            rating 'PG'
            release_date { 10.years.ago }
        end 
    end

.. code-block:: ruby

    # in spec/models/movie_spec.rb
    describe Movie do
        it 'should include rating and year in full name' do
            # 'build' creates but doesn't save object; 'create' also saves it
            movie = FactoryBot.build(:movie, :title => 'Milk', :rating => 'R')
            expect(movie.name_with_rating).to eq 'Milk (R)' 
        end
    end

In database-backed MVC apps, one other source of “real” objects for use in tests is **fixtures**—a 
set of objects whose existence is guaranteed and fixed, and can be assumed by all test cases. 
The term *fixture* comes from the manufacturing world: a test fixture is a device that holds 
or supports the item under test. Since all state in Rails SaaS apps is kept in the database, 
a fixture file defines a set of objects that is automatically loaded into the test database 
before
tests are run, so you can use those objects in your tests without first setting them up. Rails 
looks for fixtures in a file containing objects expressed in **YAML** (a recursive acronym for 
YAML Ain’t Markup Language), as Figure 8.9 shows. Following convention over configuration, 
the fixtures for the :code:`Movie` model are loaded from :code:`spec/fixtures/movies.yml`, and are available 
to your specs via their symbolic names, as Figure 8.9 shows.

.. code-block:: yaml

    # spec/fixtures/movies.yml
    milk_movie:
        id: 1
        title: Milk
        rating: R
        release_date: 2008-11-26

    documentary_movie:
        id: 2
        title: Food, Inc. 
        release_date: 2008-09-07

.. code-block:: ruby

    # spec/models/movie_spec.rb:

    require 'rails_helper.rb'

    describe Movie do
        fixtures :movies
        it 'includes rating and year in full name' do
            movie = movies(:milk_movie)
            expect(movie.name_with_rating).to eq('Milk (R)')
        end
    end

But unless used carefully, fixtures can interfere with tests being **I**\ndependent, as every 
test now depends implicitly on the fixture state, so changing the fixtures might change 
the behavior of tests. In addition, although any given test probably relies on only one or 
two fixtures, the union of fixtures required by all tests can become unwieldy. Therefore, 
fixtures should be used very sparingly if at all, and primarily for truly fixed data that, 
in production, would not be expected to change while the app is running but need to be present 
in order for it to work. For example, at deployment time the app might allow setting the 
timezone or language in which it operates and storing the preferences in the database, and 
many aspects of the app might rely on these values being set to a legal value. Having a 
fixture that “hardwires” some values suitable for testing is reasonable in this case. As a 
rule of thumb, *use factories for kinds of data that normally change while the app is running, 
and consider fixtures for data that doesn’t change but must be present for the app to work at all.*

Whether you use factories or fixtures, the test framework itself (in our case, RSpec) is 
responsible for restoring the state of the world to look “pristine” before the next test 
case runs, just as with doubles. Specifically, the database is completely erased, and any 
fixtures are then reloaded. Doing this *test teardown* before every single example keeps tests 
**I**\ndependent.

**Self-Check 8.6.1.** *Suppose a test suite contains a test that adds a model object to a table 
and then expects to find a certain number of model objects in the table as a result. Explain 
how the use of fixtures may affect the Independence of the tests in this suite, and how the 
use of Factories can remedy this problem.*

    If the fixtures file is ever changed so that the number of items initially populating that 
    table changes, this test may suddenly start failing because its assumptions about the initial 
    state of the table no longer hold. In contrast, a factory can be used to quickly create only 
    those objects needed for each test or example group on demand, so no test needs to depend 
    on any global “initial state” of the database.
