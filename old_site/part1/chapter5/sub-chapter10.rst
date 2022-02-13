Concluding Remarks: Languages, Productivity, and Beauty
====================================
This chapter showed two examples of using language features to support the productive creation of beautiful 
and concise code. The first is the use of metaprogramming, closures and higher-order functions to allow model 
validations and controller filters to be DRYly declared in a single place, yet called from multiple points 
in the code. Validations and filters are an example of **aspect-oriented programming** (AOP), a methodology that 
has been criticized because it obfuscates control flow but whose well-circumscribed use can enhance DRYness. 
All in all, validations, filters, and association helper methods are worth studying as successful examples of 
tastefully exploiting programming language features to enhance code beauty and productivity.

The second example is the design choices reflected in the association helper methods. For example, you may have 
noticed that while the foreign key field for a Movie object associated with a review is called :code:`movie_id`, the 
association helper methods allow us to reference :code:`review.movie`, allowing our code to focus on the *architectural* 
association between Movies
and Reviews rather than the *implementation detail* of the foreign key names. You could certainly manipulate the :code:`movie_id` or 
:code:`review_id` fields in the database directly, as Web applications based on less-powerful frameworks are often forced to do, 
or do so in your Rails app, as in :code:`review.movie_id=some_movie.id`. But besides being harder to read, this code hardwires 
the assumption that the foreign key field is named :code:`movie_id`, which may not be true if your models are using advanced Rails 
features such as polymorphic associations, or if ActiveRecord has been configured to interoperate with a legacy database 
that follows a differ- ent naming convention. In such cases, :code:`review.movie` and :code:`review.movie=` will still work, but referring 
to :code:`review.movie_id` will fail. Since someday your code will be legacy code, help your successors be productive—keep the 
logical structure of your entities as separate as possible from the database representation.

We might similarly ask, now that we know how associations are stored in the RDBMS, why :code:`movie.save` actually also causes a 
change to the :code:`reviews` table when we save a movie after adding a review to it. In fact, calling :code:`save` on the new review object 
would also work, but having said that a Movie has many Reviews, it just makes more sense to think of saving the Movie when 
we update which Reviews it has. In other words, it’s designed this way in order to make sense to programmers and make the 
code more beautiful.

Finally, as we saw in Section 5.8, an application framework provides direct support for the major architectural components 
of the application (in our case, models, views, and con- trollers), but any large software system contains many other kinds 
of code as well. Indeed, some of the examples of that section are best understood as additional patterns for solving software 
problems—a theme to which we will frequently return, and that we treat in depth in Chapter 11.
