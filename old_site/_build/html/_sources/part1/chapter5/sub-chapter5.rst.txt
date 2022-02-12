Through-Associations
====================================
Referring back to Figure 5.9, there are direct associations between Moviegoers and Reviews as well as 
between Movies and Reviews. But since any given Review is associated with both a Moviegoer and a Movie, 
we could say that there’s an *indirect* association between Moviegoers and Movies. For example, we might 
ask “What are all the movies Gloria has reviewed?” or “Which moviegoers have reviewed *Inception*?” Indeed, 
line 13 in Figure 5.11 essentially answers the second question.

.. code-block:: ruby
    :linenos:

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

This kind of indirect association is so common that Rails and other frameworks provide an abstraction 
to simplify its use. It’s sometimes called a *through-association*, since Moviegoers are related to Movies 
*through* their reviews and vice versa. Figure 5.15 shows how to use the :code:`:through` option to Rails’ :code:`has_many` 
to represent this indirect association. You can similarly add :code:`has_many :moviegoers, :through=>:reviews` to the Movie model, and 
write :code:`movie.moviegoers` to ask which moviegoers are associated with (wrote reviews for) a given movie.

How is a through-association “traversed” in the database? Referring again to Figure 5.10, finding all the movies reviewed 
by Gloria first requires forming the Cartesian product of the *three* tables (:code:`movies, reviews, moviegoers`), resulting in a 
table that conceptually has 27
rows and 9 columns in our example. From this table we then select those rows for which the movie’s ID matches the 
review’s movie_id and the moviegoer’s ID matches the review’s moviegoer_id. Extending the explanation of Section 5.4, 
the SQL query might look like this:

.. code-block:: ruby
    :linenos:

    # in moviegoer.rb:
    class Moviegoer
        has_many :reviews
        has_many :movies , :through
        # ... other moviegoer model code
    end
    gloria = Moviegoer.where(:name => 'Gloria')
    gloria_movies = gloria.movies
    # MAY work, but a bad idea - see caption:
    gloria.movies << Movie.where(:title => 'Inception') # Don't do this!

.. code-block:: ruby
    :linenos:

    class Review < ActiveRecord::Base
        # review is valid only if it's associated with a movie:
        validates :movie_id , :presence => true
        # can ALSO require that the referenced movie itself be valid
        # in order for the review to be valid:
        validates_associated :movie
    end

.. code-block:: sql

    SELECT movies .*
        FROM movies JOIN reviews ON movies.id = reviews.movie_id 
        JOIN moviegoers ON moviegoers.id = reviews.moviegoer_id 
        WHERE moviegoers.id = 1;

For efficiency, the intermediate Cartesian product table is usually not materialized, that is, 
not explicitly constructed by the database. Indeed, Rails 3 has a sophisticated relational algebra 
engine that constructs and performs optimized SQL join queries for traversing associations.

The point of this section and the previous one, though, is not only to explain how to use associations, but 
also to point out the elegant use of duck typing and metaprogramming that makes them possible. In Figure 
5.12(c) you added :code:`has_many :reviews` to the Movie class. The :code:`has_many` method performs some metaprogramming 
to define the new instance method :code:`reviews=` that we used in Figure 5.11. :code:`has_many` is not a declaration, but 
a regular method call that does all of this work at runtime, adding several new instance methods to your 
model class to help manage the association. As you’ve no doubt guessed, convention over configuration 
determines the name of the new method, the table it will use in the database, and so on.

Associations are one of the most feature-rich aspects of Rails, so take a good look at the full documentation 
for them. In particular:


• Just like ActiveRecord lifecycle hooks, associations provide additional hooks that can be triggered when objects are added to or removed from an association (such as when new Reviews are added for a Movie), which are distinct from the lifecycle hooks of Movies or Reviews themselves.
• Validations can be declared on associated models, as Figure 5.16 shows.
• Because calling :code:`save` or :code:`save!` on an object that uses associations also affects the associated objects, various caveats apply to what happens if any of the saves fails. For example, if you have just created a new Movie and two new Reviews to link to it, and you now try to save the Movie, any of the three saves could fail if the objects aren’t valid (among other reasons).
• Additional options to association methods control what happens to “owned” objects when an “owning” object is destroyed. For example, :code:`has_many :reviews, dependent: destroy` specifies that the reviews belonging to a movie should be deleted from the database if the movie is destroyed.

**Self-Check 5.5.1.** *Describe in English the steps required to determine all the moviegoers who have reviewed a movie 
with some given* :code:`id` *(primary key).*

    Find all the reviews whose :code:`movie_id` field contains the id of the movie of interest. For each review, find the 
    moviegoer whose :code:`id` matches the review’s :code:`moviegoer_id` field.