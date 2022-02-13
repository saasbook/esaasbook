Other Types of Code
====================================
The basic Rails app structure is apparent from the arrangement of the app directory: there are models 
backed by the database; views that render to HTML; controllers that should contain the bare minimum code 
to mediate between models and views; and view helpers (subdirectory :code:`helpers`) for code whose only job 
is to “prettify” model information in the views.

In this section we describe many other types of code necessary in large apps that don’t fit neatly into 
any of the above categories. There’s no fixed consensus on where these go in a Rails app, but it’s probably 
helpful to create additional subdirectories under :code:`app`, since anything in that directory is automatically 
loaded and available within your Rails app.

Our short (and incomplete) list of examples of other types of useful objects can be divided into three 
categories, based on the main role of each object type:

1. Objects that factor out code (presenter, value object, adapter/decorator) provide a place to put additional code that works directly to help a particular model, view, or controller, but isn’t part of the core functionality of the class it helps.
2. Objects that DRY out code (concerns, automations) allow reuse of behaviors.
3. Objects that encapsulate coupling (service object, form object, query object, policy object) perform operations that express inherent dependencies among different classes, so that those dependencies don’t creep into the classes themselves.

**Presenters** (sometimes called **view objects**) contain code that helps in rendering complex views. Recall from Section 4.1 
that Rails views are really view templates: ideally they contain little or no code other than calls to view helpers. But 
sometimes the code needed to gracefully manipulate and present a view starts getting too heavyweight to stuff into a view 
helper, which is just a namespace of methods that get mixed into views. Presenters are full classes and provide a more 
appropriate place for complex view logic.

**Value objects** encapsulate a type of object whose comparisons are based on values. For example, consider an object 
representing a range of dates. Depending on your app’s needs, you might define one such object instance to be “less than” 
another if its starting date is earlier, or if its ending date is earlier; you could also come up with a definition 
for “between.” Encapsulating such an object in a class lets you define the spaceship comparison operator :code:`<=>` on instances 
of that class, so mixed-in methods like sort will “just work.”

**Adapters and decorators** are design patterns related to the Open-Closed Principle 11.4 and Dependency Injection Principle 11.6. 
As their name suggests, these typically provide extra functionality to a particular class, usually a model.

**Concerns** are complex behaviors mixed into multiple models. For example, the Apache Solr engine adds sophisticated 
full-text searching to any database-backed app. Any Ac- tiveRecord model that “mixes in” Solr gets new search methods 
added in. A simpler example might be allowing any model to be “voted on” (likes/dislikes): the functionality of managing 
and storing vote information is generic, but each model needs to track it separately. A third example might be allowing 
any model to be associated with an uploaded file. Concerns should be used with care because they represent a kind of 
inheritance, whereas (as Chapter 11 describes) cleaner code can often be achieved by preferring composition over inheritance.

**Automations** are just that—automated workflows that save you from having to manually repeat actions, usually related to 
app management and deployment. For example, creating fake staging data for your app would be a great candidate for 
automation, since the data
needs to be re-created each time the app is deployed to staging. Most Rails app automations are best accomplished by adding 
:code:`rake` tasks, since these have access to the app’s classes, environment settings, and so on, though that’s certainly not the 
only way to do it.

**Service objects** typically perform a complex operation that touches multiple models, so its logic doesn’t naturally fit into 
a single model. For example, finalizing a purchase on an e-commerce site might touch a table of sales transactions, a table 
of inventory, and a table representing the customer’s orders. These tables probably back three different models. A service 
object is often stateless (not backed by its own database table) but it can be helpful to include an instance of 
:code:`ActiveModel::Errors` as part of the object, so the object’s er- ror reporting is just like that of ActiveRecord models, 
making it easy for controllers to call the object and report its errors. Service objects in Rails apps are particularly 
useful when combined with a **database transaction** to ensure that either all the updates occur or none do.

**Form objects** encapsulate the processing of a single form that may update multiple models. Continuing the example above, 
a single form for completing a purchase may include information that updates the customer’s shipping address, the history 
of all orders, and so on. The form object contains logic that coordinates the changes to the various models when the form 
is submitted.

**Query objects** can similarly encapsulate queries that touch many different models. While a query in model A can use joins 
and eager loading (Section 12.7 to reference fields in model B, such queries often end up exposing substantial details of 
each of the models, introducing coupling between them. While this coupling is necessary in order to perform the query, 
encapsulating it in a query object allows the models themselves to remain decoupled from each other and easier to test.

**Policy objects** can be thought of as a special case of service object: they encapsulate policies, such as “who is allowed to 
do what,” especially those that touch multiple models and therefore don’t naturally belong in any of them. For example, 
consider an airline loy- alty program that reserves its best seats for VIP frequent flyers. The policy decision of “Is 
customer X allowed to reserve seat Y on flight Z” may depend on many factors, including the customer’s status level, how 
full the flight is, and so on. A policy object knows how to retrieve the necessary details from the relevant model classes 
and make a policy decision.

**Self-Check 5.8.1.** *Rails database migrations are an example of which of the kinds of code described in 
this section?*

    Migrations are an example of automation, since the same migration code is used to update the development, 
    test, and production databases.

**Self-Check 5.8.2.** *True or false: Query objects exist because Rails makes it illegal/impossible for an ActiveRecord 
query defined in model A to make reference to fields in model B.*

    False: ActiveRecord queries constructed as a result of associations (such as “A has many
    Bs”) necessarily refer to other models, and any query defined in model A can join with and refer to any fields 
    in model B. But a query object lets you extract such logic into its own class when the queries get so complex 
    that they expose too much detail about model B to model A.
