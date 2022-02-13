Open/Closed Principle
====================================
The **Open/Closed Principle** (OCP) of SOLID states that classes should be “open for 
extension, but closed against modification.” That is, it should be possible to 
extend the behavior of classes without modifying existing code on which other 
classes or apps depend.

While adding subclasses that inherit from a base class is one way to extend existing 
classes, it’s often not enough by itself. Figure 11.10 shows why the presence of :code:`case`-based
dispatching logic—one variant of the *Case Statement* design smell—suggests a possible OCP violation.

.. code-block:: ruby
    :linenos:

    class Report 
        def output
            formatter = 
            case @format 
            when :html
                HtmlFormatter.new(self) 
            when :pdf
                PdfFormatter.new(self)
                # ... etc
            end 
        end
    end

Depending on the specific case, various design patterns can help. One problem that the smelly 
code in Figure 11.10 is trying to solve is that the desired subclass of :code:`Formatter` isn’t known 
until runtime, when it is stored in the :code:`@format` instance variable. The **abstract factory pattern** 
provides a common interface for instantiating an object whose subclass may not be known until 
runtime. Ruby’s duck typing and metaprogramming enable a particularly elegant implementation 
of this pattern, as Figure 11.11 shows. (In statically-typed languages, to “work around” the 
type system, we have to create a factory method for each subclass and have them all implement 
a common interface—hence the name of the pattern.)

.. code-block:: ruby
    :linenos:

    class Report
        def output
            formatter_class = 
            begin
                @format.to_s.classify.constantize
            rescue NameError
                # ...handle 'invalid formatter type'
            end
            formatter = formatter_class.send(:new, self)
            # etc
        end
    end

Another approach is to take advantage of the **Strategy pattern** or **Template Method pattern**. Both 
support the case in which there is a general approach to doing a task but many possible variants. 
The difference between the two is the level at which commonality is captured. With Template 
Method, although the implementation of each step may differ, the set of steps is the same for 
all variants; hence it is usually implemented using inheritance. With Strategy, the overall 
task is the same, but the set of steps may be different in each variant; hence it is usually 
implemented using composition. Figure 11.12 shows how either pattern could be applied to the 
report formatter. If every kind of formatter followed the same high- level steps—for example, 
generate the header, generate the report body, and then generate the footer—we could use 
Template Method. On the other hand, if the steps themselves were quite different, it would 
make more sense to use Strategy.

An example of the Strategy pattern in the wild is OmniAuth (Section 5.2): many apps need 
third-party authentication, and the steps are quite different depending on the auth
provider, but the API to all of them is the same. Indeed, OmniAuth even refers to its 
plug-ins as “strategies.”

A different kind of OCP violation arises when we want to *add* behaviors to an existing class 
and discover that we cannot do so without modifying it. For example, PDF files can be 
generated with or without password protection and with or without a “Draft” watermark across 
the background. Both features amount to “tacking on” some extra behavior to what :code:`PdfFormatter` 
already does. If you’ve done a lot of object-oriented programming, your first thought might 
therefore be to solve the problem using inheritance, as the UML diagram in Figure 11.13 (left) 
shows, but there are four permutations of features so you’d end up with four subclasses with 
duplication across them—hardly DRY. Fortunately, the **decorator pattern** can help: we “decorate” 
a class or method by wrapping it in an enhanced version that has the same API, allowing us to 
compose multiple decorations as needed. Figure 11.14 shows the code corresponding to the more 
elegant decorator-based design of the PDF format-er shown in Figure 11.13 (right).

.. code-block:: ruby
    :linenos:

    class PdfFormatter
        def initialize ; ... ; end
        def output ; ... ; end
    end
    class PdfWithPasswordFormatter < PdfFormatter
        def initialize(base) ; @base = base ; end
        def protect_with_password(original_output) ; ... ; end
        def output ; protect_with_password @base.output ; end
        end  
    class PdfWithWatermarkFormatter < PdfFormatter
        def initialize(base) ; @base = base ; end
        def add_watermark(original_output) ; ... ; end
        def output ; add_watermark @base.output ; end
    end
    # If we just want a plain PDF
    formatter = PdfFormatter.new
    # If we want a "draft" watermark
    formatter = PdfWithWatermarkFormatter.new(PdfFormatter.new)
    # Both password protection and watermark
    formatter = PdfWithWatermarkFormatter.new(
    PdfWithPasswordFormatter.new(PdfFormatter.new))

In the wild, the ActiveSupport module of Rails provides method-level decoration via 
:code:`alias_method_chain`, which is very useful in conjunction with Ruby’s open classes, as Figure 
11.15 shows. A more interesting example of Decorator in the wild is the Rack application server 
we’ve been using since Chapter 3. The heart of Rack is a “middleware” module that receives an 
HTTP request and returns a three-element array consisting of an HTTP response code, HTTP headers, 
and a response body. A Rack-based application spec- ifies a “stack” of middleware components 
that all requests traverse: to add a behavior to an HTTP request (for example, to intercept 
certain requests as OmniAuth does to initiate an authentication flow), we decorate the basic 
HTTP request behavior. Additional decorators add support for SSL (Secure Sockets Layer), 
measuring app performance, and some types of HTTP caching.

.. code-block:: ruby
    :linenos:

    # reopen Mailer class and decorate its send_email method.
    class Mailer
        alias_method_chain :send_email, :cc
        def send_email_with_cc(recipient,body) # this is our new method
            send_email_without_cc(recipient,body) # will call original method
            copy_sender(body)
        end
    end
    # now we have two methods:
    send_email(...)            # calls send_email_with_cc
    send_email_with_cc(...)    # same thing
    send_email_without_cc(...) # call (renamed) original method

**Self-Check 11.4.1.** *Here are two statements about delegation:*

*1. A subclass delegates a behavior to an ancestor class*

*2. A class delegates a behavior to a descendant class*

*Looking at the examples of the Template Method, Strategy, and Decorator patterns (Figures 
11.12 and 11.13), which statement best describes how each pattern uses delegation?*

    In Template Method and Strategy, the ancestor class provides the “basic game plan” which 
    is customized by delegating specific behaviors to different subclasses. In Decorator, each 
    subclass provides special functionality of its own, but delegates back to the ancestor class 
    for the “basic” functionality.