The Model–View–Controller (MVC) Architecture 
====================================
All well-written and nontrivially-sized applications reflect some macroarchitectural organization, that is, 
they can be thought of as ensembles of large communicating subsystems. Put another way, while we established 
in Section 3.1 that SaaS apps follow a client–server archi- tecture, we have said nothing about the organization 
of the server application. In this section we use an architectural pattern called **Model-View-Controller** 
(usually shortened to MVC) to do so.

An application organized according to MVC consists of three main types of code. Models are concerned with the data 
manipulated by the application: how to store it, how to operate on it, and how to change it. An MVC app typically 
has a model for each type of entity manipulated by the app. For example, for a movie database app in which moviegoers 
(users) can write reviews, the entities would include (at least) movies, moviegoers, and reviews. (Towards the end 
of this chapter, a CHIPS exercise will introduce such an app, RottenPotatoes, which we’ll use throughout the rest 
of the book.)

Views are presented to the user and contain information about the models with which users can interact. The views 
serve as the interface between the system’s users and its data; for example, in RottenPotatoes you can list movies 
and add new movies by clicking on links or buttons in the views. There is only one kind of model in Rotten Potatoes, 
but it is associated with a variety of views: one view lists all the movies, another view shows the details of a 
particular movie, and yet other views appear when creating new movies or editing existing ones.

Finally, controllers mediate the interaction in both directions: when a user interacts with a view (for example, by 
clicking something on a Web page or submitting a form), a specific controller *action* corresponding to that user activity 
is invoked. Each controller corresponds to one model, and in Rails, each controller action is handled by a particular 
Ruby method within that controller. The controller can ask the model to retrieve or modify information; depending on 
the results of doing this, the controller decides what view will be presented next to the user, and supplies that view 
with any necessary information. Since RottenPotatoes has only one model (Movies), it also has only one controller, the 
Movies controller. The actions defined in that controller can handle each type of user interaction with any Movie 
view (clicking on links or buttons, for example) and contain the necessary logic to obtain Model data to *render* any 
of the Movie views.

Given that SaaS apps have always been view-centric and have always relied on a persistence tier, Rails’ choice of MVC 
as the underlying architecture might seem like an obvious fit, but there are caveats. Technically, while a View in the 
MVC sense means “any logic needed to display something,” a Rails view is really a special case called a *template* or 
*template view*, in which static markup interspersed with variable substitution is processed by a generic logic engine. 
As Figure 4.1 shows, other patterns are possible for view-oriented frameworks. Model-View-Presenter can be thought of 
as an embellishment of Model-View-Controller, and Model-View-ViewModel provides two-way interaction between the model 
and the view so that updates to the view automatically occur in the model, in contrast to MVC in which the focus is on 
reflecting model changes in the view.

As a software engineer who is experienced at learning new stacks, you will be in a position to learn by asking other 
experienced colleagues to give you a “developer’s-eye view” of a new language or framework. If you asked an experienced 
Rails developer to concisely describe the framework to you, you might get something like the following description.

• Rails is designed to support apps that follow the Model–View–Controller pattern. The framework provides powerful base classes from which your app’s models, views, and controllers inherit.
• Each Rails model is a resource type whose instances are rows in a particular table of a relational database. The database-stored models are exposed to Ruby code via a design pattern known as Active Record (Section 4.2), in which each type of model behaves more or less like a data structure whose fields (attributes) are semi-automatically seri- alized to the database.
• A Rails app is best viewed as a collection of RESTful resources, each consisting of its own model, controller, and set of views. Resources may have relationships to each other; for example, in a movie-reviewing application, we might say that Movie and Review are each a type of resource, that a single Movie can have many Reviews, and that any given Review belongs to some Movie. **Foreign keys** in the database tables (Section 5.4) capture such relationships.
• Because Rails is a server-side framework, it needs a way to map an HTTP route (Section 3.2 to code in the app that performs the correct action. The Rails routing subsystem (Section 4.4) provides a flexible way to map routes to Ruby methods located in Rails controllers. You can define routes any way you like, but if you choose to use some “standard” routes based on RESTful conventions, most of the routing is set up for you automatically.
• Rails was originally designed for apps whose client was a Web browser, so its view subsystem is designed around generating HTML pages. But it is equally easy to generate (for example) JSON data structures to return via a RESTful API.
• Rails embodies strong opinions about many mechanical details of your app’s imple- mentation, such as how classes and files are named and where they are stored. If you follow these opinions, Rails uses **convention over configuration** to save you a lot of work. For example, rather than explicitly specifying a mapping from a model class to the name of its corresponding database table or the filenames and class names of its associated controller and view files, Rails infers all these things based on simple naming rules.

**Self-Check 4.1.1.** *In which element of the MVC model is the app code “farthest away” from the user? 
Briefly explain your answer.*

    The model code is “farthest away” from the user. Users interact directly with views (which should have little to no 
    code) and code in controllers handles users’ requests for interaction, but model code is invoked only by the 
    controller when needed.