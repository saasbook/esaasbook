AJAX: Asynchronous JavaScript And XML
====================================
In 1998, Microsoft added a new function to the JavaScript global object defined by Internet Explorer 5. 
:code:`XmlHttpRequest` (usually shortened to XHR) allowed JavaScript code to initiate HTTP requests to a server 
*without* loading a new page and use the server’s response to modify the DOM of the current page. This new 
function, key to AJAX apps, allowed creating a rich interactive UI that more closely resembled a desktop 
application, as Google Maps powerfully demonstrated. Happily, you already know all the ingredients needed 
for “AJAX on Rails” programming:

1. Create a controller action or modify an existing one (Section 4.4) to handle the AJAX requests made by your JavaScript code. Rather than rendering an entire view, the action will render a partial (Section 5.1) to generate a chunk of HTML for insertion into the page.
2. Construct your RESTful URI in JavaScript and use XHR to send the HTTP request to a server. As you may have guessed, jQuery has helpful shortcuts for many common cases, so we will use jQuery’s higher-level and more powerful functions rather than calling XHR directly.
3. Because JavaScript is by definition **single-threaded** —it can only work on one task at a time until that task completes—the browser’s UI would be “frozen” while JavaScript awaited a response from the server. Therefore XHR instead returns immediately and lets you provide an event handler callback (as you did for browser-only programming in Section 6.6) that will be triggered when the server responds or an error occurs.
4. When the response arrives at the browser, your callback is passed the response content. It can use jQuery’s :code:`replaceWith()` to replace an existing element entirely, :code:`text()` or :code:`html()` to update an element’s content in place, or an animation such as :code:`hide()` to hide or show elements, as Figure 6.8 showed. Because JavaScript functions are closures (like Ruby blocks), the callback has access to all the variables visible at the time the XHR call was made, even though it executes at a later time and in a different environment.

Let’s illustrate how each step works for an AJAX feature in which clicking on a movie title shows the movie details in 
a floating window, rather than loading a separate page. Step 1 requires us to identify or create a new controller action 
that will handle the request. We will just use our existing :code:`MoviesController#show` action, so we don’t need to define a 
new route. This design decision is defensible since the AJAX version of the action performs the
same function as the original version, namely the RESTful “show” action. We will modify the show action so that if it’s 
responding to an AJAX request, it will render the simple partial in Figure 6.13(a) rather than an entire view. You could 
also define separate controller actions exclusively for AJAX, but that might be non-DRY if they duplicate the work of 
existing actions.

.. code-block:: erb

    <p> <%= movie.description %> </p>

    <%= link_to 'Edit Movie', edit_movie_path(movie), :class => 'btn btn-primary' %>
    <%= link_to 'Close', '', :id => 'closeLink', :class => 'btn btn-secondary' %>

.. code-block:: ruby

    class MoviesController < ApplicationController
        def show
            id = params[:id] # retrieve movie ID from URI route
            @movie = Movie.find(id) # look up movie by unique ID
            render(:partial => 'movie', :object => @movie) if request.xhr?
            # will render app/views/movies/show.<extension> by default
        end
    end

How does our controller action know whether show was called from JavaScript code or by a regular user-initiated 
HTTP request? Fortunately, every major JavaScript library and most browsers set an HTTP header :code:`X-Requested-With:`
XMLHttpRequest on all AJAX HTTP requests. The Rails helper method :code:`xhr?`, defined on the controller instance’s request 
object representing the incoming HTTP request, checks for the presence of this header. Figure 6.13(b) shows the 
controller action that will render the partial.

Moving on to step 2, how should our JavaScript code construct and fire off the XHR request? We want the floating window 
to appear when we click on the link that has the movie name. As Section 6.6 explained, we can “hijack” the built-in behavior 
of an element by attaching an explicit JavaScript :code:`click` handlertoit. Of course, for graceful degradation, we should only hijack the 
link behavior if JavaScript is available. So following the same strategy as the example in Section 6.6, our :code:`setup` function 
(lines 2–8 of Figure 6.14) binds the handler and creates a hidden div to display the floating window. Legacy browsers won’t 
run that function and will just get the default behavior of clicking on the link.

The actual click handler :code:`getMovieInfo` must fire off the XHR request and provide a callback function that will be called 
with the returned data. For this we use jQuery’s ajax function, which takes an object whose properties specify the 
characteristics of the AJAX request, as lines 10–15 of Figure 6.14 show. Our example shows a subset of the properties 
you can specify in this object; one important property we don’t show is :code:`data`, which can be either a string of arguments 
to append to the URI (as in Figure 3.2) or a JavaScript object, in which case the object’s properties and their values 
will be serialized into a string that can be appended to the URI. As always, such arguments would then appear in the 
:code:`params[]` hash available to our Rails controller actions.

.. code-block:: javascript
    :linenos:

    var MoviePopup = {
        setup: function() {
            // add hidden 'div' to end of page to display popup:
            let popupDiv = $('<div id="movieInfo"></div>');
            popupDiv.hide().appendTo($('body'));
            $(document).on('click', '#movies a', MoviePopup.getMovieInfo);
        }
        ,getMovieInfo: function() {
            $.ajax({type: 'GET',
                    url: $(this).attr('href'),
                    timeout: 5000,
                    success: MoviePopup.showMovieInfo,
                    error: function(xhrObj, textStatus, exception) { alert('Error!'); }
                    // 'success' and 'error' functions will be passed 3 args
                });
            return(false);
        }
        ,showMovieInfo: function(data, requestStatus, xhrObject) {
            // center a floater 1/2 as wide and 1/4 as tall as screen
            let oneFourth = Math.ceil($(window).width() / 4);
            $('#movieInfo').
            css({'left': oneFourth,  'width': 2*oneFourth, 'top': 250}).
            html(data).
            show();
            // make the Close link in the hidden element work
            $('#closeLink').click(MoviePopup.hideMovieInfo);
            return(false);  // prevent default link action
        }
        ,hideMovieInfo: function() {
            $('#movieInfo').hide();
            return(false);
        }
    };
    $(MoviePopup.setup);

Looking at the rest of the code in Figure 6.14, getting the URI that is the target of the XHR
request is easy: since the link we’re hijacking already links to the RESTful URI for showing movie details, we can 
query its href attribute, as line 10 shows. Lines 12–13 remind us that function-valued properties can specify either 
a named function, as :code:`success` does, or an anonymous function, as :code:`error` does. To keep the example simple, our error 
behavior is rudi- mentary: no matter what kind of error happens, including a timeout of 5000 ms (5 seconds), we 
just display an alert box. In case of success, we specify :code:`showMovieInfo` as the callback.

.. code-block:: css

    #movieInfo {
        padding: 2ex;
        position: absolute;
        border: 2px double grey;
        background: wheat;
    }

Some interesting CSS trickery happens in lines 20 and 23 of Figure 6.14. Since our goal is to “float” the popup window, 
we can use CSS to specify its positioning as :code:`absolute` by adding the markup in Figure 6.15. But without knowing the size 
of the browser window, we don’t know how large the floating window should be or where to place it. :code:`showMovieInfo` computes 
the dimensions and coordinates of a floating :code:`div` half as wide and one-fourth as tall as the browser window itself (line 20). 
It replaces the HTML contents of the :code:`div` with the data returned from the server (line 22), centers the element horizontally 
over the main window and 250 pixels from the top edge (line 23), and finally shows the :code:`div`, which up until now has been 
hidden (line 24).

There’s one last thing to do: the floated :code:`div` has a “Close” link that should make it disappear, so line 26 binds a very 
simple :code:`click` handler to it. Finally, :code:`showMovieInfo` returns :code:`false` (line 27). Why? Because the handler was called as the 
result of clicking on a link (:code:`<a>`) element, we need to return false to suppress the default behavior associated with 
that action, namely following the link. (For the same reason, the “Close” link’s :code:`click` handler returns :code:`false` in line 31.)

With so many different functions to call for even a simple example, it can be hard to trace the flow of control when 
debugging. While you can always use :code:`console.log(` *string* :code:`)` to write messages to your browser’s JavaScript console window, 
it’s easy to forget to remove these in production, and as Chapter 8 describes, such “:code:`printf` debugging” can be slow, 
inefficient and frustrating. In Section 6.8 we’ll introduce a better way by creating tests with Jasmine.

Lastly, there is one caveat we need to mention which could arise when you use JavaScript to dynamically create new elements 
at runtime, although it didn’t arise in this particular example. We know that :code:`$(’.myClass’).on(’click’,func)` will bind *func* 
as the click handler for all current elements that match CSS class :code:`myClass`. But if you then use JavaScript to create new 
elements matching :code:`myClass` *after* the initial page load and initial call to :code:`on`, those elements won’t have the handler bound 
to them, because on can only bind handlers to already-existing elements.

A common solution to this problem is to take advantage of a jQuery mechanism that allows an ancestor element to delegate 
event handling to a descendant, by using on’s polymorphism: :code:`$(’body’).on(’click’,’.myClass’,func)` binds the HTML body element 
(which always exists) to the :code:`click` event, but *delegates* the event to any descendant matching the selector :code:`.myClass`. Since 
the delegation check is done each time an event is processed, new elements matching :code:`.myClass` will “automagically” have 
*func* bound as their click handler when created.


**Self-Check 6.7.1.** *In line 13 of Figure 6.14, why did we write* :code:`MoviePopup.showMovieInfo` *instead of* :code:`MoviePopup.showMovieInfo()` *?*

    The former is the actual function, which is what ajax expects as its :code:`success` property, whereas the latter is a *call* 
    to the function.    

**Self-Check 6.7.2.** *In line 33 of Figure 6.14, why did we write* :code:`$(MoviePopup.setup)` *rather than* :code:`$(’MoviePopup.setup’)` *or* 
:code:`$(MoviePopup.setup())` *?*

    We need to pass the actual function to :code:`$()`, not its name or the result of calling it.

**Self-Check 6.7.3.** *Continuing Self-Check 6.7.2, if we had accidentally called* :code:`$(’MoviePopup.setup’)` *, would the result 
be a syntax error or legal but unintended behavior?*

    Recall that :code:`$()` is overloaded, and when called with a string, it tries to interpret the string as HTML markup if it 
    contains any angle brackets or a CSS selector otherwise. The latter applies in this case, so it would return an empty 
    collection, since there are no elements whose tag is :code:`MoviePopup` and whose CSS class is setup.