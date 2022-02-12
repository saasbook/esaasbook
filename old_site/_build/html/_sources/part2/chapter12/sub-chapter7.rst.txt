Avoiding Abusive Database Queries
====================================
As we saw in Section 12.2, the database will ultimately limit horizontal 
scaling—not because you run out of space to store tables, but more likely 
because a single computer can no longer sustain the necessary number of 
queries per second while remaining responsive. When that happens, you will 
need to turn to techniques such as sharding and replication, which are beyond 
the scope of this book (but see To Learn More for some suggestions).

Even on a single computer, database performance tuning is enormously complicated. 
The widely-used open source database MySQL has dozens of configuration parameters, 
and most database administrators (DBAs) will tell you that at least half a dozen of 
these are “critical” to getting good performance. Therefore, we focus on how to keep 
your database usage within the limit that will allow it to be hosted by a PaaS provider: 
Heroku, Amazon Web Services, Microsoft Azure, and others all offer hosted relational 
databases managed by professional DBAs responsible for baseline tuning. Many useful 
SaaS apps can be built at this scale—for example, all of Pivotal Tracker fits in a 
database on a single computer.

One way to relieve pressure on your database is to avoid needlessly expensive queries. 
Two common mistakes for less-experienced SaaS authors arise in the presence of associations:

1. The :math:`n+1` *queries* problem occurs when traversing an association performs more queries than necessary.
2. The *table* scan problem occurs when your tables lack the proper **indices** to speed up certain queries.

.. code-block:: ruby
    :linenos:

    # assumes class Moviegoer with has_many :movies, :through => :reviews

    # in controller method:
    @fans = Moviegoer.where("zip = ?", code) # table scan if no index!

    # in view:
    - @fans.each do |fan|
      - fan.movies.each do |movie|
        // BAD: each time thru this loop causes a new database query!
        %p= movie.title

    # better: eager loading of the association in controller.
    # Rails automatically traverses the through-association between
    # Moviegoers and Movies through Reviews
    @fans = Moviegoer.where("zip = ?", code).includes(:movies)
    # GOOD: preloading movies reviewed by fans avoids N queries in view.
    
    # BAD: preload association but don't use it in view:
    - @fans.each do |fan|
        %p= @fan.name
        // BAD: we never used the :movies that were preloaded!

Lines 1–17 of Figure 12.8 illustrate the so-called n+1 queries problem when traversing 
associations, and also show why the problem is more likely to arise when code creeps into 
your views: there would be no way for the view to know the damage it was causing. Of course,
just as bad is eager loading of information you won’t use, as in lines 18–21 of Figure 12.8. 
The :code:`bullet` gem helps detect both problems.

.. code-block:: ruby
    :linenos:

    class AddEmailIndexToMoviegoers < ActiveRecord::Migration 
        def change
            add_index 'moviegoers', 'email', :unique => true
            # :unique is optional - see text for important warning!
            add_index 'moviegoers', 'zip' 
        end
    end

Another database abuse to avoid is queries that result in a **full table scan**. Consider line 4 
of Figure 12.8: in the worst case, the database would have to examine every row of the 
:code:`moviegoers` table to find a match on the :code:`email` column, so the query will run more and more 
slowly as the table grows, taking time :math:`O(n)` for a table with n rows. The solution is to add a 
**database index** on the :code:`moviegoers.email` column, as Figure 12.9 shows. An index is a separate 
data structure maintained by the database that uses **hashing** techniques over the column values 
to allow constant-time access to any row when that column is used as the constraint. You can 
have more than one index on a given table and even have indices based on the values of multiple 
columns. Besides obvious attributes named explicitly in :code:`where` queries, *foreign keys* (the subject 
of the association) should usually be indexed. For example, in the example in Figure 12.8, the 
:code:`moviegoer_id` field in the :code:`reviews` table would need an index in order to speed up the query 
implied by :code:`fan.movies`.

Of course, indices aren’t free: each index takes up space proportional to the number of table 
rows, and since every index on a table must be updated when table rows are added or modified, 
updates to heavily-indexed tables may be slowed down. However, because of the read-mostly 
behavior of typical SaaS apps and their relatively simple queries compared to other 
database-backed systems such as Online Transaction Processing (OLTP), your app will likely 
run into many other bottlenecks before indices begin to limit its performance. Figure 12.10 
shows an example of the dramatic performance improvement provided by indices.

**Self-Check 12.7.1.** *An index on a database table usually speeds up ____ at the 
expense of ____ and ____.*

    Query performance at the expense of space and table-update performance.