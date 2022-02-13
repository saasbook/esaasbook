Demeter Principle 
====================================

The Demeter Principle or **Law of Demeter** states informally: “Talk to your friends—don’t get 
intimate with strangers.” Specifically, a method can call other methods in its own class, 
and methods on the classes of its own instance variables; everything else is taboo. Demeter 
isn’t originally part of the SOLID guidelines, as Figure 11.4 explains, but we include it 
here since it is highly applicable to Ruby and SaaS, and we opportunistically hijack the **D** 
in SOLID to represent it.

The Demeter Principle is easily illustrated by example. Suppose RottenPotatoes has made deals 
with movie theaters so that moviegoers can buy movie tickets directly via RottenPotatoes by 
maintaining a credit balance (for example, by receiving movie theater gift cards).

Figure 11.21 shows an implementation of this behavior that contains a Demeter Principle 
violation. A problem arises if we ever change the implementation of Wallet—for example, if we 
change :code:`credit_balance` to :code:`cash_balance`, or add :code:`points_balance` to allow moviegoers to accumulate 
PotatoPoints by becoming top reviewers. All of a sudden, the :code:`MovieTheater` class, which is 
“twice removed” from :code:`Wallet`, would have to change.

Two design smells can tip us off to possible Demeter violations. One is **inappropriate intimacy**: 
the :code:`collect_money` method manipulates the :code:`credit_balance` attribute of :code:`Wallet` directly, even 
though managing that attribute is the :code:`Wallet` class’s responsibility. (When the same kind of 
inappropriate intimacy occurs repeatedly throughout a class, it’s sometimes called **feature envy**, 
because :code:`Moviegoer` “wishes it had access to” the features managed by :code:`Wallet`.) Another smell that 
arises in tests is the *mock trainwreck*, which occurs in lines 25–27 of Figure 11.21: to test 
code that violates Demeter, we find ourselves setting up a “chain” of mocks that will be used 
when we call the method under test.

.. code-block:: ruby
    :linenos:

    # Better: delegate credit_balance so MovieTheater only accesses Moviegoer
    class Moviegoer
        def credit_balance
            self.wallet.credit_balance  # delegation
        end
    end
    class MovieTheater
        def collect_money(moviegoer,amount)
            if moviegoer.credit_balance >= amount
            moviegoer.credit_balance -= due_amount
            @collected_amount += due_amount
            else
            raise InsufficientFundsError
            end
        end
    end

.. code-block:: ruby
    :linenos:

    class Wallet
        attr_reader :credit_balance # no longer attr_accessor!
        def withdraw(amount)
            raise InsufficientFundsError if amount > @credit_balance
            @credit_balance -= amount
            amount
        end
    end
    class Moviegoer
        # behavior delegation
        def pay(amount)
            wallet.withdraw(amount)
        end
    end
    class MovieTheater
        def collect_money(moviegoer, amount)
            @collected_amount += moviegoer.pay(amount)
        end
    end

Once again, delegation comes to the rescue. A simple improvement comes from delegating the 
:code:`credit_balance` attribute, as Figure 11.22 (top) shows. But the best delegation is that in 
Figure 11.22 (bottom), since now the behavior of payment is entirely encapsulated within 
:code:`Wallet`, as is the decision of when to raise an error for failed payments.

Inappropriate intimacy and Demeter violations can arise in any situation where you feel you are 
“reaching through” an interface to get some task done, thereby exposing yourself to dependency 
on implementation details of a class that should really be none of your business. Three design 
patterns address common scenarios that could otherwise lead to Demeter violations. One is the 
Visitor pattern, in which a data structure is traversed and you provide a callback method to 
execute for each member of the data structure, allowing you to “visit” each element while 
remaining ignorant of the way the data structure is organized. Indeed, the “data structure” 
could even be materialized lazily as you visit the different nodes, rather than existing 
statically all at once. An example of this pattern in the wild is the Nokogiri gem, which 
supports traversal of HTML and XML documents organized as a tree: in addition to searching 
for a specific element in a document, you can have Nokogiri traverse the document and call 
a visitor method you provide at each document node.

A simple special case of Visitor is the **Iterator pattern**, which is so pervasive in Ruby 
(you use it anytime you use :code:`each`) that many Rubyists hardly think of it as a pattern. Iterator 
separates the implementation of traversing a collection from the behavior you want to apply 
to each collection element. Without iterators, the behavior would have to “reach into” the 
collection, thereby knowing inappropriately intimate details of how the collection is organized.

The last design pattern that can help with some cases of Demeter violations is the **Observer 
pattern**, which is used when one class (the observer) wants to be kept aware of what another 
class is doing (the subject) without knowing the details of the subject’s implementation. The 
Observer design pattern provides a canonical way for the subject to maintain a list of its 
observers and notify them automatically of any state changes in which they have indicated 
interest, using a narrow interface to separate the concept of observation from the specifics 
of what each observer does with the information.

While the Ruby standard library includes a mixin called :code:`Observable`, Rails’ ActiveSupport 
provides a more concise Observer that lets you observe any model’s ActiveRecord lifecycle hooks 
(:code:`after_save` and so on), introduced in Section 5.1. Figure 11.23 shows how easy it is to add 
an :code:`EmailList` class to RottenPotatoes that “subscribes” to two kinds of state changes:

.. code-block:: ruby
    :linenos:

    class EmailList
        observe Review
        def after_create(review)
            moviegoers = review.moviegoers # from has_many :through, remember?
            self.email(moviegoers, "A new review for #{review.movie} is up.")
        end
        observe Moviegoer
        def after_create(moviegoer)
            self.email([moviegoer], "Welcome, #{moviegoer.name}!")
        end
        def self.email ; ... ; end
    end

1. When a new review is added, it emails all moviegoers who have already reviewed that same movie.
2. When a new moviegoer signs up, it sends her a “Welcome” email.

In addition to ActiveRecord lifecycle hooks, Rails caching, which we will encounter in 
Chapter 12, is another example of the Observer pattern in the wild: the cache for each type 
of ActiveRecord model observes the model instance in order to know when model instances
become stale and should be removed from the cache. The observer doesn’t have to know the 
implementation details of the observed class—it just gets called at the right time, like 
Iterator and Visitor.

To close out this section, it’s worth pointing out an example that looks like it violates 
Demeter, but really doesn’t. It’s common in Rails views (say, for a :code:`Review`) to see code such

.. code-block:: erb

    <p> Review of: <%= @review.movie.title %> </p> 
    <p> Written by: <%= @review.moviegoer.name %> </p>

Aren’t these Demeter violations? It’s a judgment call: strictly speaking, a :code:`review` shouldn’t 
know the implementation details of :code:`movie`, but it’s hard to argue that creating delegate methods 
:code:`Review#movie_title` and :code:`Review#moviegoer_name` would enhance readability in this case. The 
general opinion in the Rails community is that it’s acceptable for views whose purpose is to 
display object relationships to also expose those relationships in the view code, so examples 
like this are usually allowed to stand.

**Self-Check 11.7.1.** *Ben Bitdiddle is a purist about Demeter violations, and 
he objects to the expression* :code:`@movie.reviews.average_rating` *in the movie details view, 
which shows a movie’s average review score. How would you placate Ben and fix this Demeter 
violation?*

    .. code-block:: ruby
        :linenos:
        
        # naive way:
        class Movie
            has_many :reviews
            def average_rating
                self.reviews.average_rating # delegate to Review#average_rating
            end
        end
        # Rails shortcut:
        class Movie
            has_many :reviews
            delegate :average_rating, :to => :review
        end

**Self-Check 11.7.2.** *Notwithstanding that “delegation is the key mechanism” for resolving Demeter 
violations, why should you be concerned if you find yourself delegating many methods from class 
A to class B just to resolve Demeter violations present in class C?*

    You might ask yourself whether there should be a direct relationship between class C and class 
    B, or whether class A has “feature envy” for class B, indicating that the division of 
    responsibilities between A and B might need to be reengineered.