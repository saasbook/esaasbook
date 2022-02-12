RESTful Routes for Associations
====================================
How should we RESTfully refer to actions associated with movie reviews? In particular, at least when creating 
or updating a review, we need a way to link it to a moviegoer and a movie. Presumably the moviegoer will be 
the :code:`@current_user` we set up in Section 5.2. But what about the movie?

Chapter 7 discusses Behavior-Driven Design, which emphasizes that development should be driven by scenarios that 
describe actual user behaviors. According to this view, since it only makes sense to create a review when you have 
a movie in mind, most likely the “Create Review” functionality will be accessible from a button or link on the Show 
Movie Details page for a particular movie. Therefore, at the moment we display this control, we know what
movie the review is going to be associated with. The question is how to get this information to the :code:`new` or :code:`create` 
method in the :code:`ReviewsController`.

.. code-block:: ruby

    # in routes.rb, change the line 'resources :movies' to:
    resources :movies do
    resources :reviews
    end

One method we might use is that when the user visits a movie’s Detail page, we could use the :code:`session[]`, which persists 
across requests, to remember the ID of the movie whose details have just been rendered as the “current movie.” When 
:code:`ReviewsController#new` is called, we’d retrieve that ID from the :code:`session[]` and associate it with the review by populating 
a hidden form field in the review, which in turn will be available to :code:`ReviewsController#create`. However, this approach 
isn’t RESTful, since the movie ID—a critical piece of information for creating a review—is “hidden” in the session.

A more RESTful alternative, which makes the movie ID explicit, is to make the RESTful routes themselves reflect the 
logical “nesting” of Reviews inside Movies, as the top part of Figure 5.17 shows. Since Movie is the “owning” side of 
the association, it’s the outer resource. Just as the original :code:`resources :movies` provided a set of RESTful URI helpers 
for CRUD actions on movies, this *nested resource* route specification provides a set of RESTful URI helpers for CRUD 
actions on *reviews that are owned by a movie*. The bottom part of Figure 5.17 summarizes the new routes, which are 
provided in *addition* to the basic RESTful routes on Movies that we’ve been using all along. Note that via convention 
over configuration, the URI wildcard :code:`:id` will match the ID of the resource itself—that is, the ID of a review—and 
Rails chooses the “outer” resource name to make :code:`:movie_id` capture the ID of the “owning” resource. The ID values will 
therefore be available in controller actions as :code:`params[:id]` (the review) and :code:`params[:movie_id]` (the movie with which 
the review will be associated).

Figure 5.18 shows a simplified example of using such nested routes to create the views and actions associated with a new 
review. Of particular note is the use of a before-filter in :code:`ReviewsController` to ensure that before a review is created, 
two conditions are true:

1. :code:`@current_user` is set (that is, someone is logged in and will “own” the new review).
2. The movie captured from the route (Figure 5.17) as :code:`params[:movie_id]` exists in the database.

.. code-block:: ruby
    :linenos:

    class ReviewsController < ApplicationController 
        before_filter :has_moviegoer_and_movie , :only => [:new, :create] 
        protected
        def has_moviegoer_and_movie
            unless @current_user
                flash[:warning] = 'You must be logged in to create a review.' 
                redirect_to login_path
            end
            unless (@movie = Movie.where(:id => params[:movie_id]))
                flash[:warning] = 'Review must be for an existing movie.'
                redirect_to movies_path 
            end
        end 

        public 
        def new
            @review = @movie.reviews.build 
        end

        def create
        # since moviegoer_id is a protected attribute that won't get
        # assigned by the mass-assignment from params[:review], we set it 
        # by using the << method on the association. We could also
        # set it manually with review.moviegoer = @current_user. 
        @current_user.reviews << @movie.reviews.build(params[:review]) 
        redirect_to movie_path(@movie)
        end 
    end

.. code-block:: erb

    <h1> New Review for <%= @movie.title %> </h1>

    <%= form_tag movie_reviews_path(@movie), class: 'form' do %>
        <label class="col-form-label"> How many potatoes:</label>
        <%= select_tag 'review[potatoes]', options_for_select(1..5), class: 'form-control' %>
        <%= submit_tag 'Create Review', :class => 'btn btn-success' %>
    <% end %>

If either condition is not met, the user is redirected to an appropriate page with an error message 
explaining what happened. If both conditions are met, the controller instance variables :code:`@current_user` 
and :code:`@movie` become accessible to the controller action and view.

The view uses the :code:`@movie` variable to create a submission path for the form using the :code:`movie_review_path` helper 
(Figure 5.17 again). When that form is submitted, once again :code:`movie_id` is parsed from the route and checked by 
the before-filter prior to calling the :code:`create` action. Similarly, we could link to the page for creating a new 
review by calling :code:`link_to` with the route helper :code:`new_movie_review_path(@movie)` as its URI argument.

**Self-Check 5.6.1.** *Why must we provide values for a review’s* :code:`movie_id` *and* :code:`moviegoer_id` *to the* 
:code:`new` *and* :code:`create` *actions in* :code:`ReviewsController` *, but not to the edit and update actions?*

    Once the review is created, the stored values of its :code:`movie_id` and :code:`moviegoer_id` fields tell us 
    the associated movie and moviegoer.