Dependency Injection Principle
====================================
The dependency injection principle (DIP), sometimes also called dependency inversion, 
states that if two classes depend on each other but their implementations may change, 
it would be better for them to both depend on a separate abstract interface that is 
“injected” between them.

Suppose RottenPotatoes now adds email marketing—interested moviegoers can receive
emails with discounts on their favorite movies. RottenPotatoes integrates with the external
email marketing service MailerMonkey to do this job:

.. code-block:: ruby
    :linenos:

    class EmailList
        attr_reader :mailer
        delegate :send_email, :to => :mailer
        def initialize 
            @mailer = MailerMonkey.new
        end
    end
    # in RottenPotatoes EmailListController:
    def advertise_discount_for_movie
        moviegoers = Moviegoer.interested_in params[:movie_id]
        EmailList.new.send_email_to moviegoers
    end

Suppose the feature is so successful that you decide to extend the mechanism so that 
moviegoers who are on the Amiko social network can opt to have these emails forwarded 
to their Amiko friends as well, using the new :math:`\text{Amiko}` gem that wraps Amiko’s RESTful API 
for friend lists, posting on walls, messaging, and so on. There are two problems, however.

First, :code:`EmailList#initialize` has a hardcoded dependency on :math:`\text{MailerMonkey}`, but now we will 
sometimes need to use :math:`\text{Amiko}` instead. This runtime variation is the problem solved by dependency 
injection—since we won’t know until runtime which type of mailer we’ll need, we modify 
:code:`EmailList#initialize` so we can “inject” the correct value at runtime:

.. code-block:: ruby
    :linenos:

    class EmailList
        attr_reader :mailer
        delegate :send_email, :to => :mailer
        def initialize(mailer_type)
            @mailer = mailer_type.new
        end
    end
    # in RottenPotatoes EmailListController:
    def advertise_discount_for_movie
        moviegoers = Moviegoer.interested_in params[:movie_id]
        mailer = if Config.has_amiko? then Amiko else MailerMonkey end
        EmailList.new(mailer).send_email_to moviegoers
    end

You can think of DIP as injecting an additional seam between two classes, and indeed, 
in statically compiled languages DIP helps with testability. This benefit is less apparent 
in Ruby, since as we’ve seen we can create seams almost anywhere we want at runtime using 
mocking or stubbing in conjunction with Ruby’s dynamic language features.

The second problem is that :math:`\text{Amiko}` exposes a different and more complex API than the 
simple :code:`send_email` method provided by :math:`\text{MailerMonkey}` (to which :code:`EmailList#send_email` delegates 
in line 3), yet our controller method is already set up to call send_email on the mailer 
object. The **Adapter pattern** can help us here: it’s designed to convert an existing API into 
one that’s compatible with an existing caller. In this case, we can define a new class 
:math:`\text{AmikoAdapter}` that converts the more complex Amiko API into the simpler one that our controller 
expects, by providing the same :code:`send_email` method that :math:`\text{MailerMonkey}` provides:

.. code-block:: ruby
    :linenos:

    class AmikoAdapter
        def initialize ; @amiko = Amiko.new(...) ; end
        def send_email
            @amiko.authenticate(...)
            @amiko.send_message(...)
        end
    end
    # Change the controller method to use the adapter:
    def advertise_discount_for_movie
        moviegoers = Moviegoer.interested_in params[:movie_id]
        mailer = if Config.has_amiko? then AmikoAdapter else MailerMonkey end
        EmailList.new(mailer).send_email_to moviegoers
    end

When the Adapter pattern not only converts an existing API but also simplifies it—for 
example, the :math:`\text{Amiko}` gem also provides many other Amiko functions unrelated to email, but 
AmikoAdapter only “adapts” the email-specific part of that API—it is sometimes called 
the **Façade pattern**.

Lastly, even in cases where the email strategy is known when the app starts up, what if we 
want to disable email sending altogether from time to time? Figure 11.19 (top) shows a naive 
approach: we have moved the logic for determining which emailer to use into a new :math:`\text{Config}` class, 
but we still have to “condition out” the email-sending logic in the controller method if email 
is disabled. But if there are other places in the app where a similar check must be performed, 
the same condition logic would have to be replicated there (shotgun surgery). A better 
alternative is the **Null Object pattern**, in which we create a “dummy” object that has all the 
same behaviors as a real object but doesn’t do anything when those behaviors are called. Figure 
11.19 (bottom) applies the Null Object pattern to this example, avoiding the proliferation of 
conditionals throughout the code.

.. code-block:: ruby
    :linenos:

    class Config
        def self.email_enabled? ; ... ; end
        def self.emailer ; if has_amiko? then Amiko else MailerMonkey end ; end
    end
    def advertise_discount_for_movie
        if Config.email_enabled?
            moviegoers = Moviegoer.interested_in(params[:movie_id]) 
            EmailList.new(Config.emailer).send_email_to(moviegoers)
        end 
    end

.. code-block:: ruby
    :linenos:

    class Config
        def self.emailer
            if email_disabled? then NullMailer else
                if has_amiko? then AmikoAdapter else MailerMonkey end
            end
        end
    end
    class NullMailer
        def initialize ; end
        def send_email ; true ; end
    end
    def advertise_discount_for_movie
        moviegoers = Moviegoer.interested_in(params[:movie_id])
        EmailList.new(Config.emailer).send_email_to(moviegoers)
    end

Figure 11.20 shows the UML class diagrams corresponding to the various versions of our
DIP example.

An interesting relative of the Adapter and Façade patterns is the **Proxy pattern**, in which
one object “stands in” for another that has the same API. The client talks to the proxy 
instead of the original object; the proxy may forward some requests directly to the original 
object (that is, delegate them) but may take other actions on different requests, perhaps 
for reasons of performance or efficiency.

Two classic examples of this pattern are found in ActiveRecord itself. First, the object 
returned by ActiveRecord’s :code:`all`, :code:`where` and :code:`find`-based methods quacks like a collection, but 
it’s actually a proxy object that doesn’t even do the query until you force the issue by asking 
for one of the collection’s elements. That is why you can build up complex queries with multiple 
:code:`where`\s without paying the cost of doing the query each time. The second is when you use 
ActiveRecord’s associations (Section 5.4: the result of evaluating :code:`@movie.reviews` quacks like 
an enumerable collection, but it’s actually a proxy object that responds to all the collection 
methods (:code:`size`, :code:`<<`, and so on), without querying the database except when it has to. Another 
example of a use for the proxy pattern would be for sending email while disconnected from 
the Internet. If the real Internet-based email service is accessed via a send_email method, a 
proxy object could provide a :code:`send_email` method that just stores an email on the local disk 
until the next time the computer is connected to the Internet. This proxy shields the client 
(email GUI) from having to change its behavior when the user isn’t connected.

**Self-Check 11.6.1.** *Why does proper use of DIP have higher impact in statically 
typed languages?*

    In such languages, you cannot create a runtime seam to override a “hardwired” behavior as 
    you can in dynamic languages like Ruby, so the seam must be provided in advance by
    injecting the dependency.