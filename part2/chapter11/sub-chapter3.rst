Single Responsibility Principle
====================================
The **Single Responsibility Principle** (SRP) of SOLID states that a class should have one 
and only one responsibility—that is, only one reason to change. For example, in Section 
5.2, when we added single sign-on to RottenPotatoes, we created a new :code:`SessionsController` 
to handle the sign-on interaction. An alternate strategy would be to augment 
:code:`MoviegoersController`, since sign-on is an action associated with moviegoers. Indeed, before 
the single sign-on approach described in Chapter 5, this was the recommended way to implementing 
password-based authentication in earlier versions of Rails. But such a scheme would require 
changing the :code:`Moviegoer` model and controller whenever we wanted to change the authentication 
strategy, even though the “essence” of a Moviegoer doesn’t really depend on how they sign 
in. In MVC, each controller should specialize in dealing with
one resource; an authenticated user session is a distinct resource from the user himself, and 
deserves its own RESTful actions and model methods. As a rule of thumb, if you cannot describe 
the responsibility of a class in 25 words or less, it may have more than one responsibility, 
and the new ones should be split out into their own classes.

In statically typed compiled languages, the cost of violating SRP is obvious: any change to a 
class requires recompilation and may also trigger recompilation or relinking of other classes 
that depend on it. Because we don’t pay this price in interpreted dynamic languages, it’s easy 
to let classes get too large and violate SRP. One tip-off is lack of **cohesion**, which is the 
degree to which the elements of a single logical entity, in this case a class, are related. 
Two methods are related if they access the same subset of instance or class variables or if 
one calls the other. The *LCOM* metric, for *Lack of Cohesion Of Methods*, measures cohesion for 
a class: in particular, it warns you if the class consists of multiple “clusters” in which 
methods within a cluster are related, but methods in one cluster aren’t strongly related to 
methods in other clusters. Figure 11.7 shows two of the most commonly used variants of the 
LCOM metric.

The *Data Clumps* design smell is one warning sign that a good class is evolving toward the 
“multiple responsibilities” antipattern. A Data Clump is a group of variables or values that 
are always passed together as arguments to a method or returned together as a set of results 
from a method. This “traveling together” is a sign that the values might really need their 
own class. Another symptom is that something that used to be a “simple” data value acquires 
new behaviors. For example, suppose a :code:`Moviegoer` has attributes :code:`phone_number` and :code:`zipcode`, and 
you want to add the ability to check the zip code for accuracy or canonicalize the formatting 
of the phone number. If you add these methods to :code:`Moviegoer`, they will reduce its cohesion 
because they form a “clique” of methods that only deal with specific instance variables. The 
alternative is to use the *Extract Class* refactoring to put these methods into a new :code:`Address` 
class, as Figure 11.8 shows.

.. code-block:: ruby
    :linenos:

    class Moviegoer
        attr_accessor :name, :street, :phone_number, :zipcode
        validates :phone_number, # ... 
        validates :zipcode, # ...
        def format_phone_number ; ... ; end
        def verify_zipcode ; ... ; end
        def format_address(street, phone_number, zipcode) # data clump
            # do formatting, calling format_phone_number and verify_zipcode
        end
    end
    # After applying Extract Class:
    class Moviegoer
        attr_accessor :name
        has_one :address
    end
    class Address
        belongs_to :moviegoer
        attr_accessor :phone_number, :zipcode
        validates :phone_number, # ... 
        validates :zipcode, # ...
        def format_address ; ... ; end # no arguments - operates on 'self'
        private  # no need to expose these now:
        def format_phone_number ; ... ; end
        def verify_zipcode ; ... ; end
    end

**Self-Check 11.3.1.** *Draw the UML class diagrams showing class architecture before and after 
the refactoring in Figure 11.8.*

    Figure 11.9 shows the UML diagrams.