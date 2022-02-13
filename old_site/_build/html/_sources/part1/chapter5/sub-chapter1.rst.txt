DRYing Out MVC: Partials, Validations and Filters
====================================
One of the core tenets of Rails is DRY—Don’t Repeat Yourself. In this section we introduce three mechanisms Rails 
provides to help you DRY out your code: model validations, view partials, and controller filters.

We start with views. A *partial* is Rails’ name for a reusable chunk of a view. When similar content must appear in 
different views, putting that content in a partial and “including” it in the separate files helps DRY out repetition. 
Our simple app already presents one opportunity: the Index (list all movies) view includes a chunk of HTML that is 
repeated for each movie in the list. We can factor out that code into a partial, and include it by reference, as 
Figure 5.1 shows.

.. code-block:: erb

    <!--  ...other code from index.html.erb here... -->
    <div class="row bg-dark text-white">
        <div class="col-6 text-center">Title and More Info</div>
        <div class="col-2 text-center">Rating</div>
        <div class="col-4 text-center">Release Date</div>
    </div>
    <%= render partial: 'movie', collection: @movies %>

.. code-block:: erb

    <div class="row">
        <div class="col-8"> <%= link_to movie.title, movie_path(movie) %> </div>
        <div class="col-2"> <%= movie.rating %> </div>
        <div class="col-2"> <%= movie.release_date.strftime('%F') %> </div>
    </div>

Partials rely heavily on convention over configuration. Their names must begin with an underscore 
(we used :code:`_movie_form.html.erb`) which is *absent from* the code that references the partial. A partial may 
be in a different directory as the view that uses it, in which case a path such as **’layouts/footer’** would 
cause Rails to look for :code:`app/views/layouts/_footer.html.erb`. A partial can access all the same instance 
variables as the view that in- cludes it, but partials that may be used from different views usually do 
not reference controller instance variables, since those may be set differently (or not at all) by different 
controller actions. A particularly nice use of a partial is to render a table or other collection in which 
all elements are the same, as Figure 5.1 demonstrates.

Partials are simple and straightforward, but the mechanisms provided by Rails for DRYing out models and controllers 
are more subtle and sophisticated. It’s common in SaaS apps to want to enforce certain validity constraints on a 
given type of model object or constraints on when certain actions can be performed. For example, when a new movie 
is added to RottenPotatoes, we may want to check that the title isn’t blank, that the release year is a valid date, 
and that the rating is one of the allowed ratings. (You may think there’s no way for the user to specify an invalid 
rating if they’re choosing it from a dropdown menu, but the request might be constructed by a malicious user or a **bot**.) 
With SaaS, you can’t trust anyone: the server must *always* check its inputs rather than trust them, or risk attack by 
methods we’ll see in Chapter 12.

As another example, perhaps we want to allow any user to add new movies, but only
allow special “admin” users to delete movies. Both examples involve specifying constraints on entities or actions, and 
although there might be many places in an app where such con- straints should be considered, the DRY philosophy urges us 
to centralize them in *one* place. Rails provides two analogous facilities for doing this: validations for models and filters 
for controllers.

.. code-block:: ruby
    :linenos:

    class Movie < ActiveRecord::Base
        def self.all_ratings ; %w[G PG PG-13 R NC-17] ; end #  shortcut: array of strings
        validates :title, :presence => true
        validates :release_date, :presence => true
        validate :released_1930_or_later # uses custom validator below
        validates :rating, :inclusion => {:in => Movie.all_ratings},
            :unless => :grandfathered?
        def released_1930_or_later
            errors.add(:release_date, 'must be 1930 or later') if
            release_date && release_date < Date.parse('1 Jan 1930')
        end
        @@grandfathered_date = Date.parse('1 Nov 1968')
        def grandfathered?
            release_date && release_date < @@grandfathered_date
        end
    end
    # try in console:
    m = Movie.new(:title => '', :rating => 'RG', :release_date => '1929-01-01')
    # force validation checks to be performed:
    m.valid?  # => false
    m.errors[:title] # => ["can't be blank"]
    m.errors[:rating] # => [] - validation skipped for grandfathered movies
    m.errors[:release_date] # => ["must be 1930 or later"]
    m.errors.full_messages # => ["Title can't be blank", "Release date must be 1930 or later"]

Model validations, like migrations, are expressed in a mini-DSL embedded in Ruby, as Figure 5.2 shows. 
Validation checks are triggered when you call the instance method :code:`valid?` or when you try to save the model 
to the database (which calls :code:`valid?` before doing so). Any validation errors are recorded in the 
:code:`ActiveModel::Errors` object associated with each model; this object is returned by the instance method errors. 
As line 6 shows,validations can be conditional: the movie’s rating is validated *unless* the movie was released 
before the ratings system went into effect (in the USA, 1 November 1968).

We can now understand lines 10–12 and 23–25 from Figure 4.9 in the last chapter. When creating or updating a movie 
fails (as indicated by a falsy return value from :code:`create` or :code:`update_attributes`), we set :code:`flash[:alert]` to an error message 
informed by the contents of the movie errors object. We then :code:`render` (*not* redirect to) the form that brought us here, 
with :code:`@movie` still holding the values the user entered the first time, so the form will be prepopulated with those 
values. A redirect would start an entire new request cycle, and :code:`@movie` would not be preserved.

In fact, validations are just a special case of a more general mechanism, Active Record lifecycle callbacks, which 
allow you to provide methods that “intercept” a model object at various relevant points in its lifecycle. Figure 5.3 
shows what callbacks are available; Figure 5.4 illustrates how to use this mechanism to “canonicalize” (standardize the 
format of)
certain model fields before the model is saved. We will see another use of lifecycle callbacks when we discuss the Observer 
design pattern in Section 11.7 and caching in Chapter 12.6.

.. code-block:: ruby
    :linenos:

    class Movie < ActiveRecord::Base
        before_save :capitalize_title
        def capitalize_title
            self.title = self.title.split(/\s+/).map(&:downcase).
            map(&:capitalize).join(' ')
        end
    end
    # now try in console:
    m = Movie.create!(:title => 'STAR  wars', :release_date => '27-5-1977', :rating => 'PG')
    m.title  # => "Star Wars"

.. code-block:: ruby
    :linenos:

    class ApplicationController < ActionController::Base
        before_filter :set_current_user
        protected # prevents method from being invoked by a route
        def set_current_user
            # we exploit the fact that the below query may return nil
            @current_user ||= Moviegoer.where(:id => session[:user_id])
            redirect_to login_path and return unless @current_user
        end
    end

Analogous to a validation is a controller filter—a method that checks whether certain conditions are true 
before an action is run, or sets up common conditions that many actions rely on. If the conditions are not 
fulfilled, the filter can choose to “stop the show” by rendering a view template or redirecting to another 
action. If the filter allows the action to proceed, it will be the action’s responsibility to provide a 
response, as usual.

As an example, an extremely common use of filters is to enforce the requirement that a user be logged in before 
certain actions can be performed. Assume for the mo- ment that we have verified the identity of some user and 
stored her primary key (ID) in :code:`session[:user_id]` to remember the fact that she has logged in. Figure 5.5 shows a 
filter that enforces that a valid user is logged in. In Section 5.2 we will show how to combine this filter with 
the other “moving parts” involved in dealing with logged-in users.

Filters normally apply to all actions in the controller, but as the documentation on filters states, :code:`:only` 
or :code:`:except` can be used to restrict a filter to guarding only certain actions. You can define multiple filters: 
they are run in the order in which they are declared. You can also define after-filters, which run after certain actions 
are completed, and around-filters, which specify actions to run before and after, as you might do for auditing or timing.

**Self-Check 5.1.1.** *Why didn’t the Rails designers choose to trigger validation when you first instantiate a 
movie using* :code:`Movie#new` *, rather than waiting until you try to persist the object?*

    As you’re filling in the attributes of the new object, it might be in a temporarily invalid state, so triggering 
    validation at that time might make it difficult to manipulate the object. Persisting the object tells Rails “I believe 
    this object is ready to be saved.”

**Self-Check 5.1.2.** *In line 5 of Figure 5.2, why can’t we write* :code:`validate released_1930_or_later` *, that is, why must the argument to* :code:`validate` 
*be either a symbol or a string?*

    If the argument is just the “bare” name of the method, Ruby will try to evaluate it at the moment it executes 
    :code:`validate`, which isn’t what we want—we want :code:`released_1930_or_later` to be called at the time any 
    validation is to occur.