Associations and Foreign Keys
====================================
An *association* is a logical relationship between two types of entities in a software architecture. 
For example, the previous CHIPS added a :code:`Moviegoer` class to RottenPotatoes; we could now add a :code:`Review`
class to allow a moviegoer to write reviews of their favorite movies. Because each review is about 
exactly one movie, but a single movie can have many reviews, we say that there is a one-to-many association 
from reviews to movies. Similarly, there is a one-to-many association from moviegoers to reviews. Figure 5.9 
shows these associations us- ing one type of **Unified Modeling Language (UML)** diagram. We will see more examples 
of UML in Chapter 11.

In Rails parlance, Figure 5.9 shows that:

• A Moviegoer has many Reviews
• A Movie has many Reviews
• A Review belongs to one Moviegoer and to one Movie

In Rails, the “permanent home” for our model objects is the database, so we need a way to represent associations 
for objects stored there. Fortunately, associations are so common that relational databases provide a special mechanism 
to support them: **foreign keys**. A foreign key is a column in one table whose job is to reference the primary key of 
another table to establish an association between the objects represented by those tables. Recall that by default, 
Rails migrations create tables whose primary key column is called :code:`id`. Figure 5.10 shows a Moviegoers table to keep 
track of different users and a Reviews table with foreign key columns :code:`moviegoer_id` and :code:`movie_id`, allowing each review 
to refer to the primary keys (ids) of the user who authored it and the movie it’s about.

For example, to find all reviews for Star Wars, we would first form the **Cartesian product** of all the rows of the 
:code:`movies` and :code:`reviews` tables by concatenating each row of the
:code:`movies` table with each possible row of the :code:`reviews` table. This would give us a new table with 9 rows (since there 
are 3 movies and 3 reviews) and 7 columns (3 from the :code:`movies` table and 4 from the :code:`reviews` table). From this large 
table, we then select only those rows for which the :code:`id` from the :code:`movies` table equals the :code:`movie_id` from the :code:`reviews` 
table, that is, only those movie-review pairs in which the review is about that movie. Finally, we select only those 
rows for which the movie :code:`id` (and therefore the review’s :code:`movie_id`) are equal to 41, the primary key ID for *Star Wars*. 
This simple example (called a **join** in relational database parlance) illustrates how complex relationships can be 
represented and manipulated using a small set of operations (relational algebra) on a collection of tables with uniform 
data layout. In SQL, the Structured Query Language used by substantially all relational databases,
the query would look something like this:

.. code-block:: ruby

    # it would be nice if we could do this:
    inception = Movie.where(:title => 'Inception')
    alice,bob = Moviegoer.find(alice_id, bob_id)
    # alice likes Inception, bob less so
    alice_review = Review.new(:potatoes => 5)
    bob_review   = Review.new(:potatoes => 3)
    # a movie has many reviews:
    inception.reviews = [alice_review, bob_review]
    # a moviegoer has many reviews:
    alice.reviews << alice_review
    bob.reviews << bob_review
    # can we find out who wrote each review?
    inception.reviews.map { |r| r.moviegoer.name } # => ['alice','bob']

.. code-block:: sql

    SELECT reviews.* 
        FROM movies JOIN reviews ON movies.id=reviews.movie_id
        WHERE movies.id = 41;

If we weren’t working with a database, though, we’d probably come up with a design in which each object of a class has 
“direct references” to its associated objects, rather than constructing the query plan above. A Moviegoer object would 
maintain an array of references to Reviews authored by that moviegoer; a Review object would maintain a reference to the 
Moviegoer who wrote it; and so on. Such a design would allow us to write code that looks like Figure 5.11.

Rails’ :code:`ActiveRecord::Associations` module supports exactly this design, as we’ll learn by doing. Apply the code changes 
in Figure 5.12 as directed in the caption, and you should then be able to start rails console and successfully execute 
the examples in Fig- ure 5.11.

.. code-block:: ruby

    # Run 'rails generate migration create_reviews' and then
    #   edit db/migrate/*_create_reviews.rb to look like this:
    class CreateReviews < ActiveRecord::Migration
        def change
            create_table 'reviews' do |t|
            t.integer    'potatoes'
            t.text       'comments'
            t.references 'moviegoer'
            t.references 'movie'
            end
        end
    end

.. code-block:: ruby

    class Review < ActiveRecord::Base
        belongs_to :movie
        belongs_to :moviegoer
    end

.. code-block:: ruby

    # place a copy of the following line anywhere inside the Movie class
    #  AND inside the Moviegoer class (idiomatically, it should go right
    #  after 'class Movie' or 'class Moviegoer'):
    has_many :reviews


How does this work? Since everything in Ruby is a method call, we know that Line 8 in Figure 5.11 is really 
a call to the instance method :code:`reviews=` on a **Movie** object. This instance method remembers its assigned value 
(an array of Alice’s and Bob’s reviews) in memory. Recall, though, that since a Review is on the “belongs to” 
side of the association (Review belongs to a Movie), to associate a review with a movie we must set the :code:`movie_id`
field for that review. *We don’t actually have to modify the movies table.* So in this simple example, the call 
to :code:`inception.reviews=` isn’t actually updating the movie record for *Inception* at all: it’s setting the :code:`movie_id` 
field of both Alice’s and Bob’s reviews to “link” them to *Inception*.

Figure 5.13 lists some of the most useful methods added to a :code:`movie` object by virtue of declaring that it :code:`has_many` reviews. 
Of particular interest is that since :code:`has_many` implies a *collection* of the owned object (Reviews), the :code:`reviews` method quacks 
like a collection. That is, you can use all the collection idioms of Figure 2.11 on it—iterate over its elements with :code:`each`, 
use functional idioms like :code:`sort`, :code:`map`, and so on, as in lines 8, 10 and 13 of Figure 5.11.

What about the :code:`belongs_to` method calls in :code:`review.rb`? As you might guess, :code:`belongs_to :movie` gives **Review** objects a movie 
instance method that looks up and returns the movie to which this review belongs. Since a review belongs to at most one 
movie, the method name is singular rather than plural, and returns a single object rather than an enumerable.

**Self-Check 5.4.1.** *In Figure 5.12(a), why did we add foreign keys (references) only to the* :code:`reviews` *table and not to the* 
:code:`moviegoers` *or* :code:`movies` *tables?*

    Since we need to associate many reviews with a single movie or moviegoer, the foreign keys must be part of the model on 
    the “owned” side of the association, in this case Reviews.

**Self-Check 5.4.2.** *In Figure 5.13, are the association accessors and setters (such as* :code:`m.reviews` *and* :code:`r.movie`
*) instance methods or class methods?*

    Instance methods, since a collection of reviews is associated with a particular movie, not with movies in general.