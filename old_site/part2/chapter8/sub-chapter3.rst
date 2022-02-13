Isolating Code: Doubles and Seams
====================================

Unit tests can be more complex if the SUT is either not a leaf method or not a pure function. We can distinguish three cases:

• The SUT has one or more *depended-on components* (DOCs), such as other methods it calls to help do its work. Test cases should isolate the SUT from those dependencies.
• The SUT has side effects when executed, that is, it causes a change in application state visible outside the test code itself. Test cases should verify that the correct side effect occurred, which involves inspecting app state outside the SUT.
• The SUT is not a pure function because its output depends not only on its input but other implicit factors, such as the time of day or a random event. Test cases should control the values of these factors to force the SUT to traverse predictable code paths.

There are two characteristics of a method that can complicate the task of creating unit tests for it. The first is 
that it has side effects The second is that it has dependencies—it calls other methods as part of doing its job.

As an example, consider testing a controller action. By design, as we have seen, controller actions shouldn’t contain 
“business logic”—instead they manage communication with
the model, calling model methods to do the real work and setting up variables to display information in the view. To 
make our example relevant to SaaS, consider a hypothetical SaaS app that allows the user to look up a movie in another 
service’s movie database, and display the movie info so the user can write a review. Here is how our hypothetical app works:

1. The :code:`Movie` model has a class (static) method :code:`find_in_tmdb` that makes a call to the API of the external service The Movie Database (TMDb) and returns an array of :code:`Movie` objects, which may be empty if there were no matches.
2. If there are no matches, the controller action should redirect the user back to the search page with an appropriate message.
3. If there is exactly one match, the controller should render a view that allows the user to enter a review for that movie.
4. Ifthereismorethanonematch,thecontrollershouldrenderadifferentviewthatallows the user to specify which movie they want to review.
5. Because the model method relies on calling an external service, the call might fail if the service doesn’t respond for some reason. In that case, we assume :code:`Movie.find_in_tmdb` will raise the exception :code:`Movie::ConnectionError`.

Figure 8.4 shows what the above controller action might look like.

.. code-block:: ruby

    class MoviesController < ApplicationController
        def review_movie
            search_string = params[:search]
            begin
            matches = Movie.find_in_tmdb(search_string)
            if matches.empty? # nothing was found
                redirect_to review_movie_path, :alert => "No matches."
            elsif matches.length == 1
                @movie = matches[0]
                render 'review_movie'
            else # more than 1 match
                @movies = matches
                render 'select_movie'
            end
            rescue Movie::ConnectionError => err
            redirect_to review_movie_path, :alert => "Error contacting TMDb: #{err.message}"
            end
        end
    end

How would we unit-test this controller action? The Arrange step consists of preparing :code:`params` 
to hold some search string. The Act step consists of calling the controller action with that 
search string. But the Assert step depends on whether the call to :code:`find_in_tmdb` returns an 
empty array, an array of exactly one match, an array containing more than one match, or 
raises an exception because of an error communicating with The Movie Database. Indeed, as 
items 2–5 in the list above show, there are really four test cases required here, and to 
test each of them, we essentially need to be able to control the *behavior of the call* to 
:code:`find_in_tmdb`.

.. code-block:: ruby

    describe MoviesController do
        describe 'looking up movie' do
            it 'redirects to search page if no match' do
            allow(Movie).to receive(:find_in_tmdb).and_return( [] )
            post 'review_movie', {'search_string' => 'I Am Big Bird'}
            expect(response).to redirect_to(review_movie_path)
            end
        end
    end

Michael Feathers (Feathers 2004) defines a seam as “a place where you can alter 
behavior in your program without editing in that place.” In our case, we want to 
alter (control) the behavior of :code:`find_in_tmdb` but without changing the source code 
of the controller action. Recall that one ability afforded by metaprogramming is 
being able to modify code while a program is running. In this case, the strategy 
would be to *temporarily* modify :code:`find_in_tmdb` so that *instead of calling the real method, 
it calls a “fake” method whose behavior we control* and can change for each test case.

Such a construction is called a **method stub**, and is easy to implement in languages that 
support metaprogramming. The RSpec testing framework provides direct support for this, 
as Figure 8.5 shows: the Arrange part of a test now includes setting up a stub for the 
method, and specifying that when the stub is called, it should return an empty array, 
ensuring that :code:`matches.empty?` in line 6 of Figure 8.4 will be true, causing line 7 to 
be executed next. As is typical for a testing framework, RSpec “un-registers” any stubs 
after each example (test case), making the stub visible only to that test case and thereby 
keeping tests **I**\ndependent. Later we will show how to group together sets of examples that 
rely on the same precondition setup, so that tests can be DRY as well.

Keeping in mind that every Ruby function call is a method call on an object, line 4 of 
Figure 8.5 can be read as follows: “Allow the :code:`Movie` class (which is itself an object) to 
receive a call to its (class) method :code:`find_in_tmdb`, and return an empty array as the return 
value of that call.” Note that it is *not an error* for :code:`find_in_tmdb` not to be called: the 
stub setup only specifies what should happen *if* that method is called. If we wanted to 
express the test condition that the method *must* be called, we would replace :code:`allow` with 
:code:`expect`. In that case, line 4 would be both an Arrange step defining a stub and an Assert 
step specifying that the test should fail if the stub isn’t actually called. RSpec 
automatically verifies :code:`expect...to receive` assertions at the end of each example, so the 
test wouldn’t need an extra line to check if the stub was called—simply using :code:`expect` 
rather than :code:`allow` to set up the stub distinguishes the two cases.

In this case, :code:`receive()` creates a seam by overriding a method in place, without us having to 
edit the file containing the original method (although in this case, the original method 
doesn’t even exist yet). Seams are also important when it comes to adding new code to your 
application, but in the rest of this chapter we will see many more examples of seams in 
testing. Seams are useful in testing because they let us break dependencies between a piece 
of code we want to test and its collaborators, allowing the collaborators to behave differently 
under test than they would in real life.

The kind of seam we just described is called a **method stub** or simply *stub*, because it is a 
piece of code that replaces the real method’s code with a controllable or fixed behavior
for testing purposes. A **mock object** or simply *mock* is a simplified “stunt double” of an object 
that can only mimic a few fixed behaviors of the object, such as returning fixed values for 
specific attributes. Mocks are useful when a real object would be complex to instantiate 
because it has other dependencies, yet only a few specific properties of the object are 
necessary for the SUT to work properly. The term **test double** generically covers these and a 
few other types of seams. Figure 8.6 summarizes typical strategies for using these doubles in 
various unit-testing scenarios, and Figure 8.7 shows examples of each strategy using RSpec.

.. code-block:: ruby

    # 1. Pure leaf function: test critical values and noncritical regions
    it 'occurs when multiple of 4 but not 100' do
        expect(leap?(2008)).to be_truthy
        end
    it 'does not occur when multiple of 400' do
        expect(leap?(2000)).to be_falsy
    end

    # 2. Using doubles for explicit dependencies such as collaborators
    #    UI.background() calls Defcon.level() to determine display color
    it 'colors the UI red if Defcon is 2 or lower' do
        # Arrange: stub Defcon to return 2
        allow(Defcon).to receive(:level).and_return(2)  
        expect(UI.background).to eq('red')        # Act and Assert
    end

    # 3. Has implicit dependencies such as time
    it 'runs backups on Tuesdays' do
        # Arrange: stub Date.today to return Tues 2020-02-04
        allow(Date).to receive(:today).and_return(Time.local(2020,2,4))
        expect(run_backups_today?()).to be_truthy  # Act and Assert
    end

    # 4. Has side effects (verbose version)
    it 'lowers Defcon level by 1' do
        # Arrange: check previous value of state
        before = Defcon.level()
        post_alert("Hostile craft detected")    # Act
        expect(Defcon.level()).to eq(before - 1) # Asset
    end

    # Shortcut version passing a callable to `expect`
    it 'lowers Defcon level by 1' do
        expect { post_alert("Hostile craft detected") }.
            to change { Defcon.level() }.by(-1)
    end

**Self-Check 8.3.1.** *Name two likely violations of FIRST that arise when unit tests 
actually call an external service as part of testing.*

    The test may no longer be Fast, since it takes much longer to call an external 
    service than to compute locally. The test may no longer be Repeatable, since 
    circumstances beyond our control could affect its outcome, such as the temporary 
    unavailability of the external service.
