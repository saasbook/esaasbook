Single-Page Apps and JSON APIs 
====================================
Google Maps was an early example of the emerging category called client-side single-page apps (SPAs). In a 
SPA, after the initial page load from the server, all interaction appears to the user to occur without any page 
reloads. While we won’t develop a full SPA in this section, we will show the techniques necessary to do so.

So far, we have concentrated on using JavaScript to enhance server-centric SaaS apps; since HTML has long been 
the *lingua franca* of content served by those apps, rendering a partial and using JavaScript to insert the “ready-made” 
partial into the DOM was a sensible way to proceed. But with SPAs, it’s more common for client-side code to request 
some “raw” data from the server, and use that data to construct or modify DOM elements. How can a Rails app return 
raw data rather than HTML markup to JavaScript client code?

One simple mechanism is for the controller action to use :code:`render :text` to return a plain string. But what if we need 
to send structured data to the client? As you have probably guessed, JSON solves that problem, even though the X in 
AJAX stands for XML, which was originally believed to be the standard that would take hold for data interchange. 
In practice, modern browsers’ JSAPIs include a function JSON.parse that converts a string of JSON into the corresponding 
JavaScript object(s).

To use JSON in our client-side code, we must address three questions:

1. How do we get the server app to generate JSON in response to AJAX requests, rather than rendering HTML view templates or partials?
2. How does the client specify that it expects a JSON response, and how does it use the JSON response data to modify the DOM?
3. When testing AJAX requests that expect JSON responses, how can we use fixtures to “stub out the server” and test these behaviors in isolation, as we did in Section 6.8?

The first question is easy. If you have control over the server code, your Rails controller actions can emit JSON rather 
than an XML or HTML template by using render :code:`:json=>` *object*, which sends a JSON representation of an object back to the client 
as the single response from the controller action. Like rendering a template, you are only allowed a single call to :code:`render` 
per action, so all the response data for a given controller action must be packed into a single JSON object.


.. code-block:: javascript
    Review.first.to_json
    #   => "{\"created_at\":\"2012-10-01T20:44:42Z\", \"id\":1, \"movie_id\":1,
        \"moviegoer_id\":2,\"potatoes\":3,\"updated_at\":\"2013-07-28T18:01:35Z\"}"

.. code-block:: javascript
    :linenos:

    let MoviePopupJson = {
        // 'setup' function omitted for brevity
        getMovieInfo: function() {
            $.ajax({type: 'GET',
                    dataType: 'json',
                    url: $(this).attr('href'),
                    success: MoviePopupJson.showMovieInfo
                    // 'timeout' and 'error' functions omitted for brevity
                });
            return(false);
        }
        ,showMovieInfo: function(jsonData, requestStatus, xhrObject) {
            // center a floater 1/2 as wide and 1/4 as tall as screen
            let oneFourth = Math.ceil($(window).width() / 4);
            $('#movieInfo').
            css({'left': oneFourth,  'width': 2*oneFourth, 'top': 250}).
            html($('<p>' + jsonData.description + '</p>'),
                    $('<a id="closeLink" href="#"></a>')).
            show();
            // make the Close link in the hidden element work
            $('#closeLink').click(MoviePopupJson.hideMovieInfo);
            return(false);  // prevent default link action
        }
        // hideMovieInfo omitted for brevity
    };

:code:`render :json` works by calling :code:`to_json` on object to create the string to send back to the client. 
The default implementation of :code:`to_json` can serialize simple ActiveRecord objects, as Figure 6.25 shows.

To make an AJAX call that expects a JSON-encoded response, we just ensure that the argument object passed to :code:`$.ajax` includes 
a dataType property whose value is the string :code:`json`, as Figure 6.26 shows. The presence of this property tells jQuery to 
automatically call :code:`JSON.parse` on the returned data, so you don’t have to do so yourself.

How can we test this code without calling the server every time? Happily, Jasmine- jQuery’s fixture mechanism allows us 
to specify JSON fixtures as well as HTML fixtures, as Figure 6.27 shows.

.. code-block:: javascript
    :linenos:

    describe('MoviePopupJson', function() {
        describe('successful AJAX call', function() {
            beforeEach(function() { 
            loadFixtures('movie_row.html');
            let jsonResponse = getJSONFixture('movie_info.json');
            spyOn($, 'ajax').and.callFake(function(ajaxArgs) {
                ajaxArgs.success(jsonResponse, '200');
            });
            $('#movies a').trigger('click');
            });
            // 'it' clauses are same as in movie_popup_spec.js
        });
    });


**Self-Check 6.10.1.** *In Figure 6.27 showing the use of a JSON fixture, why do we also still need the HTML 
fixture to be loaded in line 4?*

    Line 9 tries to trigger the click handler for an element matching #movies a, and if we don’t load the HTML 
    fixture representing a row of the movies table, no such element will exist. (Indeed, the :code:`MoviePopupJson.setup` 
    function tries to bind a click handler on this element, so that would also fail.) This is an example of using 
    both an HTML fixture to simulate the user clicking on a page element and a JSON fixture to simulate a successful 
    response from the server in response to that click.
