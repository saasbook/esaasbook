Rails Models: Databases and Active Record
====================================

Every nontrivial application needs to store and manipulate persistent data. For many 
SaaS applications, the two key requirements may be expressed as follows:

1. The app must be able to store different types of data items, or *entities*, in which all instances of a particular type of entity share a common set of *attributes*. For example, in RottenPotatoes, the attributes for a movie entity might include title, release date, MPAA rating, and so on. All movies have the same attributes, though the attribute *values* are different for each movie.
2. The app must be able to express relationships among different kinds of entities. Returning to RottenPotatoes, two other entities might be movie reviews and moviegoers. A movie has many reviews and a moviegoer has many reviews, though any single review is associated with exactly one movie and one moviegoer.

The above two requirements are so common in business that *Relational database management systems* (RDBMSs) 
evolved in the early 1970s as elegant structured-storage systems whose design was based on a formalism for 
representing such structure and relationships. An RDBMS stores a collection of *tables*, each of which stores 
entities with a common set of *attributes*. One row in the table corresponds to one entity, and the columns 
in that row correspond to the attribute values for that entity. The movies table for RottenPotatoes would 
include columns for :code:`title, rating, release_date,` and :code:`description,` and the rows of the table look like Figure 4.2.

In Rails, data takes the form of a set of resources stored in a relational database. Amazingly, you don’t need to know much 
about how RDBMSs work to get started with Rails, though understanding their basic operation becomes more important as 
your apps begin to comprise multiple types of resources with relationships among them.

Therefore, the key questions to address in order to understand the role of the database in the Rails 
model–view–controller architecture are as follows:

1. What is the correspondence between how an instance of a resource (say, the information about a specific movie) is stored in the database and how it is represented in the programming language used by the framework (in this case, Ruby)?
2. What software mechanisms mediate between those two representations, and what programming abstractions do those mechanisms expose?

In our case, the answer is that Rails implements the **Active Record architectural pattern**. In this pattern, a Rails model is a 
class backed by a specific table of an RDBMS. An instance of the class (for example, the entry for a single movie) corresponds 
to a single row in that table. The model has built-in behaviors that directly operate on the database:

• Create a new row in the table (representing a new object),
• Read an existing row into a single object instance,
• Update an existing row with new attribute values from a modified object instance, 
• Delete a row (destroying the object’s data forever).

This collection of four commands is often abbreviated **CRUD**. The combination of table name and id uniquely identifies a 
model stored in the database, and as we will see, is therefore how objects are usually referenced in RESTful routes 
in Rails apps.

Unlike some other SaaS frameworks in which the abstraction exposed to the developer is the connection to the database itself, 
Active Record gives each model the knowledge of how to create, read, update, and delete instances of itself in the database 
(CRUD). That is, all of the logic for “talking to” the database, and (critically) for how to marshal and unmarshal
(serialize or deserialize) attributes, is implicitly included in each model. Rails accomplishes this by providing a 
class :code:`ActiveRecord::Base` from which your models will inherit. In OOP terms, Create and Read are class methods, since 
they define actions on the *collection* of model instances as a whole, whereas Update and Delete are instance methods, 
since they define actions on a specific model instance.

Remarkably, as Figure 4.3 shows, simply defining a class that descends from Rails’ ActiveRecord base class provides all 
the necessary machinery to “connect” the model to the database. Specifically:

• The directory :code:`app/models` is expected to contain one Ruby code file per model. The file name is determined by converting the model’s name to :code:`lower_snake_case`, so a file :code:`app/models/movie.rb` is expected to define the class Movie.
• The database table name is determined by converting the model’s class name to :code:`lower_snake_case` *and* pluralizing it. For example, instances of model :code:`AccountCode` would be stored in table :code:`account_codes`.
• Theattributesofthemodel,andtheirtypes(string,integer,date,andsoon),areinferred from the names and types of the table’s columns.
• The model automatically has class (static) methods :code:`new` and :code:`create`, among others, that expect a hash of arguments whose keys match those attribute names and whose values supply the attribute values for a movie instance to be created in memory (:code:`new`) or immediately persisted in the database (:code:`create`).

In fact, just about the only thing this class definition *doesn’t* do is create the actual table in the database; we must do 
that ourselves, by first telling Rails how to actually connect to the database, and then providing instructions for creating 
the necessary model table(s) in our schema. When a new Rails app is created from a scratch, the automatically-generated file 
:code:`config/database.yml` specifies how to connect to the database. By default, Rails apps are initially configured to use SQLite, 
a lightweight single-user RDBMS, but later will see how to modify this file to connect to “industrial strength” database 
servers such as Postgres or MySQL. To create the actual table, we create and apply a *migration*—a Ruby script describing 
a set of changes to make to the database schema.

Why use migrations rather than directly issuing SQL statements such as :code:`create table`? There are many reasons, but as we will see, Rails 
defines three *environments* in which your app can run: development (when you’re coding), production (the live app containing 
real customer data), and test (used only when running automated tests). Each environment gets its own completely separate 
database, but of course, the schemata of all three databases need to be kept in sync. It is much less error-prone to write 
a single migration script and run it against each environment than to ensure you issue the exact same set of SQL commands 
three times.

To create and apply a migration, you first give the command :code:`rails generate migration` *name*, where *name* is some descriptive 
name for what the migration does; in this example, we might say :code:`rails generate migration create_movies_table`. Rails will 
create a Ruby file whose name consists of your migration’s name plus a times- tamp. The file defines a migration class with 
your specified name that descends from :code:`ActiveRecord::Migration` and has an empty change instance method. You fill in that 
method with the desired schema changes, save the file, and then run the command
:code:`rake db:migrate`, which invokes the Rails utility tool rake to run the task :code:`db:migrate`. (:code:`rake -T` shows a list of available 
tasks with brief descriptions.)

.. code-block:: ruby
    
    class Movie < ActiveRecord::Base
    end

.. code-block:: ruby

    class CreateMovies < ActiveRecord::Migration
        def change
            create_table 'movies' do |t|
            t.string 'title'
            t.string 'rating'
            t.text 'description'
            t.datetime 'release_date'
            # Add fields that let Rails automatically keep track
            # of when movies are added or modified:
            t.timestamps
            end
        end
    end

.. code-block:: ruby

    # Seed the RottenPotatoes DB with some movies.
    more_movies = [
        {:title => 'Aladdin', :rating => 'G',
            :release_date => '25-Nov-1992'},
        {:title => 'When Harry Met Sally', :rating => 'R',
            :release_date => '21-Jul-1989'},
        {:title => 'The Help', :rating => 'PG-13',
            :release_date => '10-Aug-2011'},
        {:title => 'Raiders of the Lost Ark', :rating => 'PG',
            :release_date => '12-Jun-1981'}
        ]

    more_movies.each do |movie|
        Movie.create(movie)
    end

Notice that you don’t have to specify the filename of which migration to apply: Rails tracks which migrations 
have been applied to which environments’ databases. The :code:`db:migrate` task examines the **environment variable** 
:code:`RAILS_ENV` to determine which environment to apply the migration in, defaulting to :code:`development` if not set, 
and then applies *all* pending migrations not yet applied to that database. Running :code:`rake db:migrate` multiple times is 
harmless, since migrations already applied will simply be ignored on subsequent runs.

The next CHIPS exercise gives you some hands-on practice with how the Rails implementation of Active Record actually works.

**Self-Check 4.2.1.** *What do you think would happen if you tried to run the code in the top and bottom parts of 
Figure 4.3 without having created and run the migration in the middle part of the figure?*

    An error would occur upon the first call to any method in the :code:`Movie` class that requires accessing the database, 
    since it would be unable to find any table named :code:`movies`.