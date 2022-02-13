Fallacies and Pitfalls
====================================

**Pitfall: Route with a matching view but no controller action.**

If you specify a route (say :code:`GET /movies`) that lacks a corresponding controller action 
(:code:`MoviesController#index` in this case) but *does* have a matching view (:code:`app/views/movies/index.html.erb` in this case), 
*Rails will behave as if the controller action exists but has an empty method definition.* That is, it will render 
the view, but any instance variables used in the view will be :code:`nil`. If the matching view template *does not* exist, 
Rails will signal an error when the route is used. This inconsistency is non-intuitive, so be careful when you 
set up a route that you immediately add *both* the controller action and the view template, or else add neither.


**Pitfall: Modifying the database manually rather than using migrations, or managing gems manually rather than using Bundler.**

Especially if you’ve come from other SaaS frameworks, it may be tempting to use the SQLite command line or a GUI 
database console to manually add or change database tables or to install libraries. **Don’t do it.** If you modify the 
database manually, you’ll have no consistent way to reproduce these steps in the future (for example at deployment 
time) and no way to roll back the changes in an orderly way. Also, since migrations and Gemfiles are just files that 
become part of your project, you can keep them under version control and see the entire history of your changes.

**Pitfall: Bulky controller actions or views.**

Because controller actions are the first place in your app’s code that are called when a user request arrives, it’s 
remarkably easy for the actions’ methods to get bulky—putting all kinds of logic in the controller that really 
belongs in the model. Similarly, it’s easy for code to creep into views—most commonly, a view may find itself 
calling a model method such as :code:`Movie.all`, rather than having the controller method set up a variable such 
as :code:`@movies=Movie.all` and having the view just use :code:`@movies`. Besides violating MVC, cou- pling views to models can 
interfere with caching, which we’ll explore in Chapter 5. The view should focus on displaying content and facilitating 
user input, and the controller should focus on mediating between the view and the model and set up any necessary 
variables to keep code from leaking into the view.

**Pitfall: Overstuffing the session[] hash.**

You should minimize what you put in the :code:`session[]` for two reasons. First, with the default Rails configuration, the 
session is packed into a cookie (Section 3.2), which the HTTP specification limits to 4 KiB in size. Second, and more 
importantly, bulky sessions are a
warning that your app’s actions aren’t very self-contained and therefore probably not RESTful, and may be difficult to 
use as part of a Service-Oriented Architecture. Although nothing stops you from assigning arbitrary objects to the 
session, you should keep just the ids of nec- essary objects in the session and keep the objects themselves in model 
tables in the database.

**Pitfall: Adopting a framework without a good reason.**

Software breeds complexity. The more numerous and complex the libraries on which your app relies, the more you’ll have 
to learn to write the app properly; the more resource-intensive (thus possibly slower) the app will run; the harder 
it will be to maintain; and perhaps most importantly, the more exposure surface it will have for being attacked. Use 
the simplest framework that will solve most of your problems.

The answer to the question “Should my app use framework X” should be NO by default, unless you can come up with good 
technical reasons why it should. Some examples of good reasons: the framework encapsulates a solution to a hard technical 
problem, as Stripe does for credit card processing; the framework provides low-level machinery to instantiate an architecture 
that the app follows closely, as Rails does for Model–View–Controller; or there are technological constraints requiring 
you to use the framework (“all our apps are built on framework X and that’s all we know how to maintain”).

Bad reasons include: “It’s the hot new framework”; “All the popular apps use it”; “I will be more marketable if I learn this 
framework, and this app is a good excuse to learn it”. The last one is doubly false: the most sought-after software engineers 
are those who can learn new frameworks quickly, and at any rate, a new customer-facing app is not an excuse to learn a 
framework but an artifact that your customers will rely on, and that whoever comes after you will have to maintain (if 
you’re lucky; otherwise it will just die).