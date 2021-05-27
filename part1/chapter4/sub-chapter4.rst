Routes, Controllers, and Views
====================================
We’ve now been introduced to how Rails implements the models in MVC, but when users interact with a 
SaaS app via a browser, they’re interacting with views and invoking controller actions, either by 
typing URIs into their browser (resulting in an HTTP :code:`GET`) or interacting with page elements that 
generate :code:`GET` requests (links) or :code:`POST` requests (forms). In this section we take a tour through views 
and controllers to understand the lifecycle of such a request when it hits a Rails app. We first explore 
the controllers and views corresponding to REST actions that only read model data: Index and Read. In 
Section 4.6 we consider controllers and views corresponding to actions the modify data: Create, Update, and Delete.

As we know from Section 3.2, our app will receive a request in the form of an HTTP route. The first step in a 
Rails app is therefore to determine which code in the app should be invoked to handle that route. Rails provides 
a flexible routing subsystem that maps routes to specific Ruby methods in each controller using the contents of 
the file :code:`config/routes.rb`. You can define any routes you like there, but if your app is RESTful (centered around 
CRUD requests against a set of resources) and you abide by convention over configuration, the single line :code:`resources 
’movies’` (in our case) defines a complete set of RESTful routes for a model (resource) called Movies, as Figure 4.4 shows.

Although “RESTful route and action” column in the table should look familiar from Sec- tion 3.2, we raise four 
questions about it:

1. The four CRUD actions plus the Index action should only need five routes; why are there seven?
2. Most Web browsers can only generate HTTP :code:`GET` and :code:`POST` requests; how can a browser generate a route such as Update, which uses HTTP :code:`PUT`?
3. Some routes such as :code:`show` include a variable (parameter) as part of the route URI, and others such as :code:`create` must also provide the attribute values of the entity to be created as parameters. How are these parameters and their values made available to the controller action?
4. Finally, what are the “route helper methods” referred to in the table and why are they needed?

The first question—why seven routes rather than five—is easy but subtle. We preview the answer here and will 
return to it when we discuss HTML forms in Section 4.6. A RESTful request to create a movie would typically 
include information about the movie itself—title, rating, and so on. But in a user-facing app, we need a way 
to collect that information in- teractively from the user, usually by displaying a form the user can fill in. 
Submitting the form would clearly correspond to the :code:`create` action, but what route describes *displaying* the form? 
The Rails approach is to define a default RESTful route :code:`new` that displays whatever is necessary to allow collecting 
information from the user in preparation for a :code:`create` request. A similar argument applies to :code:`update`, which requires 
a way to show the user an editable version of the *existing* resource so the user can make changes; this latter 
action is called :code:`edit` in rails, and typically displays a form pre-populated with the existing resource’s attribute values.

Turning to the second question, for historical reasons Web browsers only implement :code:`GET` (for following a link) and 
:code:`POST` (for submitting forms). To compensate, Rails’ routing mechanism lets browsers use :code:`POST` for requests that normally 
would require :code:`PUT` or :code:`DELETE`. Rails annotates the Web forms associated with such requests so that when the request is 
submitted, Rails *internally* changes the HTTP method “seen” by the controller to :code:`PUT` or :code:`DELETE` as appropriate. The 
result is that the Rails programmer can operate under the assumption that :code:`PUT` and :code:`DELETE` are actually supported, 
even though browsers don’t implement them. As a result, the *same set of routes* can handle either requests coming 
from a browser (that is, from a human being) or requests coming from another service in a SOA.

What about routes that include a parameter in the URI, such as show, or those that must also include parameters corresponding 
to attribute values for a resource, such as :code:`create`? As we will see in the code examples in this section (and you will have an 
opportunity to experiment with in the next CHIPS), the Rails routing subsystem prepares a hash called :code:`params[]` that is made 
available to the controller. With the above :code:`routes.rb` file as part of an app, typing :code:`rake routes` at the command line 
(within the root directory of your app) will list all the routes implied by that file, showing wildcard parameters with the 
colon notation introduced in Section 3.5. For example, the route for show will appear as :code:`GET /movies/:id`, which tells us 
that :code:`params[:id]` will hold the actual ID value parsed from the URI. Further, as we will see, Rails provides an easy way to 
generate an HTML form in which the form fields are named in such a way that another value in :code:`params`, in this example 
:code:`params[:movie]`, is itself a hash of key/value pairs corresponding to a :code:`Movie` object’s attributes and their desired values. 
This mechanism sounds more confusing than it actually is, as the code examples below will show.

Finally, what are “route helpers”? By convention over configuration, the route URIs will match the resource name, but as we’ll 
see later, you can override this behavior. You might, for example, decide later that you’d rather have your routes built 
around :code:`film` rather than :code:`movie`. But then any view in your app that references the old-style movie route URIs—for example, 
the page that serves the form allowing users to edit a movie’s info—would have to be changed to :code:`film`. This is the problem 
that route helpers solve: they decouple what the
route does (create, read, and so on) from the actual route URI. As the table suggests, the Ruby method :code:`movies_path` will return 
the correct URI for the route “list all movies,” *even if* the URI text itself is changed later (or for “create new movie,” 
if :code:`POST` is used as the route’s verb). Similarly :code:`movie_path(23)` will always return the correct URI for “show movie ID 23” 
(or update, edit, or destroy movie ID 23, depending on which HTTP verb is used). The route helpers also make explicit what 
the route is supposed to do, improving readability.

What about the controller methods (called controller *actions* in Rails) that handle each RESTful operation? Once again, 
convention over configuration comes to the rescue. By default, the routes created by :code:`resources ’movies’` will expect to find 
a file :code:`controllers/movies_controller.rb` that defines a class :code:`MoviesController` (which descends from the Rails-provided 
:code:`ApplicationController`, just as models descend from ActiveRecord::Base). That class will be expected to define instance methods 
:code:`index, new, create, show (read), edit, update,` and :code:`destroy,` corresponding to the RESTful actions of Figure 4.4.

Each of these controller actions generally follows a similar pattern:

1. Collect the information accompanying the RESTful request: parameters, resource IDs in the URI, and so on
2. Determine what ActiveRecord operations are necessary to fulfill the request.For example, the Index action might just require retrieving a list of all movies from the Movies table; the Update action might require identifying a resource ID from the URI, parsing the contents of a form, and using the form data to update the movie with the given ID (primary key); and so on.
3. Set instance variables for any information that will need to be displayed in the view, such as information retrieved from the database.
4. Render a view that will be returned as the result of the overall request.

That leaves only the last bullet point: how does each controller action select a view, and how is the information generated 
in the controller action made available to that view?

You should no longer be surprised to hear that part of the answer lies once again in convention over configuration. 
Controller actions do not return a value; instead, when a con- troller action finishes executing, by default Rails will 
identify and render a view named :code:`app/views/` *model-name* :code:`/action.html.erb`, for example :code:`app/views/movies/show.html.erb` for 
the show action in :code:`MoviesController`. The Rails module that choreographs how views are handled is :code:`ActionView::Base`. This 
view consists of HTML interspersed with Erb (Embedded Ruby) tags that allow the results of evaluating Ruby code to be 
interpolated into the HTML view. In particular, any instance variables set in the controller method become available in 
the view.

Re-reading the previous sentence should give you pause. Why would instance variables of one class (:code:`MoviesController`) 
be accessible to an object of a completely different class (:code:`ActionView::Base`), violating all OOP orthodoxy? The simple 
reason is that the designers of Rails thought it would make coding easier. What actually happens is that Rails creates 
an instance of :code:`ActionView::Base` to handle rendering the view, and then uses Ruby’s metaprogramming facilities to “copy” 
all of the controller’s instance variables into that new object!

• The controller code is in class :code:`MoviesController`, defined in :code:`app/controllers/movies_controller.rb` (note that the model’s class name is pluralized to form the controller file name.) Your app’s controllers all inherit from your app’s root controller :code:`ApplicationController` (in :code:`app/controllers/application_controller.rb`), which contains controller behaviors common to multiple controllers (we will meet some in Chapter 5 and in turn inherits from :code:`ActionController::Base`.
• Each instance method of the controller is named using :code:`snake_lower_case` according to the RESTful action it handles, plus the two “pseudo-actions” :code:`new` and :code:`edit`.
• The view template for each action is named the same as the controller method itself, so the view for Showing a movie would be in :code:`app/views/movies/show.html.erb`. Strangely but conveniently, each view has access to all the instance variables set in the controller actions.

There’s one last thing to notice about these views: they aren’t legal HTML! In particular, they lack an HTML :code:`DOCTYPE, 
<html>` element, and its main children :code:`<head>` and :code:`<body>`. In fact, we need to put those elements in :code:`views/application.html.erb`, 
which “wraps” all views by default, as Figure 4.6 shows.

.. code-block:: ruby

    # This file is app/controllers/movies_controller.rb
    class MoviesController < ApplicationController
        def index
            @movies = Movie.all
        end
        def show
            id = params[:id]            # retrieve movie ID from URI route
            @movie = Movie.find(id)     # look up movie by unique ID
        end
    end

.. code-block:: erb

    <h1>All Movies</h1>

    <%= link_to 'Add Movie', new_movie_path, :class => 'btn btn-primary' %>

    <div id="movies">
        <div class="row">
            <div class="col-8">Movie Title</div>
            <div class="col-2">Rating</div>
            <div class="col-2">Release Date</div>
        </div>
    <%- @movies.each do |movie| %>
        <div class="row">
            <div class="col-8"> <%= link_to movie.title, movie_path(movie) %> </div>
            <div class="col-2"> <%= movie.rating %></div>
            <div class="col-2"> <%= movie.release_date.strftime('%F') %> </div>
        </div>
    <% end %>
    </div>

.. code-block:: erb

    <h1>Details about <%= @movie.title %></h1>

    <div id="metadata">
        <ul id="details">
            <li> Rating: <%= @movie.rating %> </li>
            <li> Released on: <%= @movie.release_date.strftime('%F') %> </li>
        </ul>
    </div>

    <div id="description">
        <h2>Description:</h2>
        <p> <%= @movie.description %> </p>
    </div>

    <%= link_to 'Edit this movie', edit_movie_path(@movie), :class => 'btn' %>
    <%= link_to 'Back to movie list', movies_path, :class => 'btn btn-primary' %>


.. code-block:: erb


    <!DOCTYPE html>
        <html>
        <head>
            <title> RottenPotatoes! </title>
            <link rel="stylesheet" href="https://getbootstrap.com/docs/4.0/dist/css/bootstrap.min.css">
            <%= javascript_include_tag :application %>
            <%= csrf_meta_tags %>
        </head>
        <body>
            <div class="container">
                <%- if flash[:notice] %>
            <div class="alert alert-info text-center"><%=flash[:notice]%></div>
                <%- elsif flash[:alert] %>
            <div class="alert alert-danger text-center"><%=flash[:notice]%></div>
                <% end %>
                <%= yield %>
            </div>
        </body>
    </html>

**Self-Check 4.4.1.** *The route helper for Show or Update take an argument, as in* :code:`movie_path(@movie),` *but the route helpers for 
New and Create (* :code:`new_movie_path` and :code:`movies_path` *) do not. Why the difference?*

    The argument to the Show and Update route helpers is either an existing :code:`Movie` instance or the ID (primary key) of an existing 
    instance. Show and Update operate on existing movies, so they take an argument to identify which movie to operate on. 
    New and Create operate on not-yet-existing movies.

**Self-Check 4.4.2.** *Why doesn’t the route helper movies_path for the Index action take an argument? 
(Hint: The reason is slightly different than the answer to the previous question!)*

    The Index action just shows a list of all the movies, so no argument is needed to distinguish which movie to operate on.