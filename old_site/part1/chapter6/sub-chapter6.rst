Events and Callbacks
====================================
So far all of our DOM manipulation has been by typing JavaScript commands directly. As you’ve no doubt guessed, 
much more interesting behaviors are possible when DOM manipulation can be triggered by user actions. As part 
of the JSAPI for the DOM, browsers allow attaching JavaScript *event handlers* to the user interface: when the user 
performs a certain UI action, such as clicking a button or moving the mouse into or out of a particular HTML element, 
you can designate a JavaScript function that will be called and have the opportunity to react. This capability makes 
the page behave more like a desktop UI in which individ- ual elements respond visually to user interactions, and less 
like a static page in which any interaction causes a whole new page to be loaded and displayed.

Figure 6.9 summarizes the most important events defined by the browser’s native JSAPI and improved upon by jQuery. While 
some are triggered by user actions on DOM elements, others relate to the operation of the browser itself or to “pseudo-UI” 
events such as form submission, which may occur via clicking a Submit button, pressing the Enter key (in some browsers), 
or another JavaScript callback causing the form to be submitted. To attach a behavior to an event, simply provide a 
JavaScript function that will be called when the event *fires*. We say that this function, called a **callback** or *event handler*, 
is *bound* to that event on that DOM element. Although events are automatically triggered by the browser, you can also trigger 
them yourself: for example, :code:`e.trigger(’click’)` triggers the :code:`click` event
handler for element :code:`e`. As we will see in Section 6.8, this ability is useful when testing: you can simulate user interaction 
and check that the correct changes are applied to the DOM in response to a UI event.

Browsers define built-in behavior for some events and elements: for example, clicking on a link visits the linked page. If 
such an element also has a programmer-supplied :code:`click` handler, the handler runs first; if the handler returns a truthy value 
(Figure 6.2), the built-in behavior runs next, but if the handler returns a falsy value, the built-in behavior is suppressed. 
What if an element has *no* handler for a user-initiated event, as is the case for images? In that case, its parent element in 
the DOM tree is given the chance to respond to the event handler. For example, if you click on an :code:`img` element inside a :code:`div` 
and the :code:`img` has no click handler, then the :code:`div` will receive the click event. This process continues until some element handles 
the event or it “bubbles” all the way up to the top-level window, which may or may not have a built-in response depending on 
the event.

Our discussion of events and event handlers motivates the third common use of JavaScript’s :code:`this` keyword (recall that Section 6
.3 introduced the first two uses). When an event is handled, in the body of the event handler function, jQuery will arrange 
for :code:`this` to refer to the element to which the handler is attached (which may not be the element that originally received the 
event, if the event “bubbled up” from a descendant). However, if you were programming *without* jQuery, the value of :code:`this` in an 
event handler is the global object (:code:`document.window`), and you have to examine the event’s data structure (usually passed as 
the final argument to the handler) to identify the element that handled the event. Since han- dling events is such a common 
idiom, and most of the time an event handler wants to inspect or manipulate the state of the element on which the event was 
triggered, jQuery is written to explicitly set this to that DOM element.

Putting all these pieces together, Figure 6.10 shows the client-side JavaScript to imple- ment a checkbox that, when checked, 
will hide any movies with ratings other than G or PG. Our general strategy for JavaScript can be summarized as:

1. Identify the DOM elements we want to operate on, and make sure there is a convenient and unambiguous way of selecting them using :code:`$()`.
2. Create the necessary JavaScript functions to manipulate the elements as needed. For this simple example we can just write them down, but as we’ll see in Section 6.8, for AJAX or more complex functions we will use TDD (Chapter 8) to develop the code.
3. Define a setup function that binds the appropriate JavaScript functions to the elements and performs any other necessary DOM manipulation.
4. Arrange to call the setup function once the document is loaded.

.. code-block:: javascript
    :linenos:

    let MovieListFilter = {
        filter_adult: function () {
            // 'this' is *unwrapped* element that received event (checkbox)
            if ($(this).is(':checked')) {
            $('.adult').hide();
            } else {
            $('.adult').show();
            };
        },
        setup: function() {
            // construct checkbox with label
            let labelAndCheckbox =
            $('<label for="filter">Only movies suitable for children</label>' +
                '<input type="checkbox" id="filter"/>' );
            labelAndCheckbox.insertBefore('#movies');
            $('#filter').change(MovieListFilter.filter_adult);
        }
    }
    $(MovieListFilter.setup); // run setup function when document ready

For Step 1, we modify our existing Rails movie list view to attach the CSS class adult
to any table rows for movies rated other than G or PG. All we have to do is change line 12
of the Index template (Figure 4.5) as follows, thereby allowing us to write :code:`$(’.adult’)` to
select those rows:

.. code-block:: erb

    <div class="row<%= (' adult' unless movie.rating =~ /^G|PG$/) %>">

For Step 2, we provide the function :code:`filter_adult`, which we will arrange to be called whenever the checkbox is 
checked or unchecked. As lines 4–8 of Figure 6.10 show, if the checkbox is checked, the adult movie rows are 
hidden; if unchecked, they are revealed. Recall from Figure 6.8 that :code:`:checked` is one of jQuery’s built-in behaviors 
for checking the state of an element. Remember also that jQuery selectors such as :code:`$(’.adult’)` generally return a 
collection of matching elements, and actions like :code:`hide()` are applied to the whole collection.

Why does line 4 refer to :code:`$(this)` rather than just :code:`this`? The mechanism by which user interactions are dispatched to 
JavaScript functions is part of the browser’s JSAPI, so the value of :code:`this` is the *browser’s* representation of the 
checkbox (the element that handled the event). In order to use the more powerful jQuery features such as :code:`is(’:checked’)`, 
we have to “wrap” the native element as a jQuery element by calling :code:`$` on it in order to give it these special powers. 
The first row of Figure 6.12 shows this usage of :code:`$`.

For Step 3, we provide the setup function, which does two things. First, it creates a label and a checkbox (lines 12–14), 
using the :code:`$` mechanism shown in the second row of Figure 6.12, and inserts them just before the :code:`movies` table (line 15). 
Again, by creating a jQuery element we are able to call :code:`insertBefore` on it, which is not part of the browser’s built-in 
JSAPI. Most jQuery functions such as :code:`insertBefore` return the target object itself, allowing “chaining” of function calls as we’ve seen in Ruby.

Second, the setup function binds the :code:`filter_adult` function to the checkbox’s change handler. You might have expected to 
bind to the checkbox’s :code:`click` handler, but :code:`change` is more robust because it’s an example of a “pseudo-UI” event: it fires 
whether the checkbox was changed by a mouse click, a keypress (for browsers that have keyboard navigation turned on, such 
as for users with disabilities that prevent use of a mouse), or even by other JavaScript code. The :code:`submit` event on forms 
is similar: it’s better to bind to that event than to bind to the :code:`click` handler on the form-submit button, in case the 
user submits the form by hitting the Enter key.

Why didn’t we just add the label and checkbox to the Rails view template? The reason is our design guideline of graceful 
degradation: by using JavaScript to create the checkbox, legacy browsers will not render the checkbox at all. If the checkbox 
was part of the view template, users of legacy browsers would still see the checkbox, but nothing would happen when they 
clicked on it.

Why does line 16 refer to :code:`MovieListFilter.filter_adult?` Couldn’t it just refer to :code:`filter_adult?` No, because that would imply 
that :code:`filter_adult` is a variable name visible in the scope of the :code:`setup` function, but in fact it’s not a variable name at 
all—it’s just a function-valued property of the object :code:`MovieListFilter`, which is a (global) variable. It is good JavaScript 
practice to create one or a few global objects to “encapsulate” your functions as properties, rather than writing a bunch 
of functions and polluting the global namespace with their names.

The last step is Step 4, which is to arrange for the :code:`setup` function to be called. For historical reasons, JavaScript 
code associated with a page can begin executing *before* the entire page has been loaded and the DOM fully parsed. This 
feature was more important for responsiveness when browsers and Internet connections were slower. Nonetheless, we usually 
want to wait until the page is finished loading and the entire DOM has been parsed, or else we might be trying to bind 
callbacks on elements that don’t exist yet! Line 19 does this, adding :code:`MovieListFilter.filter_adult` to the list of functions 
to be executed once the page is finished loading, as the last row of Figure 6.12 shows. Since you can call :code:`$()` multiple 
times to run multiple setup functions, you can keep each file’s setup function together with that file’s functionality, 
as we’ve done here. To run this example place all the code from Figure 6.12 in :code:`app/assets/javascripts/movie_list_filter.js`.

This was a dense example, but it illustrates the basic jQuery functionality you’ll need for many UI enhancements. The figures 
and tables in this section generalize the techniques introduced in the example, so it’s worth spending some time perusing 
them. In particular, Figure 6.12 summarizes the four different ways to use jQuery’s :code:`$`, all of which we’ve now seen.

Finally, most of jQuery’s events are based on the built-in events recognized by browsers, but you can also define your own 
custom events and use :code:`trigger` to trigger them, and many jQuery-based libraries do just that. For example, Bootstrap’s plugin 
for showing a **modal window** defines a custom event :code:`show` that is generated when a modal window is displayed and another custom 
event :code:`shown` that is generated when that window is dismissed. Your own code can listen for these events in order to take 
actions before or after the modal is displayed. In your own code, you might enclose menus for month and day in a single 
outer element such as a :code:`div`, and then define a custom :code:`update` event on the :code:`div` that checks that the month and day are 
compatible. You could then isolate the checking code in a separate event handler for :code:`update`, and use :code:`trigger` to call it 
from within the change handlers for the individual
month and day menus. This is one way that custom handlers help DRY out your JavaScript code.

**Self-Check 6.6.1.** *Explain why calling* :code:`$(selector)` *is equivalent to calling* :code:`$(window.document).find(selector)`.

    :code:`document` is a property of the browser’s built-in global object (:code:`window`) that refers to the browser’s representation of the 
    root of the DOM. Wrapping the document element using :code:`$` gives it access to jQuery functions such as :code:`find`, which locates all 
    elements matching the selector that are in the subtree of its target; in this case, the target is the DOM root, so it will 
    find any matching elements in the entire document.

**Self-Check 6.6.2.** *In Self-Check 6.6.1, why did we need to write* :code:`$(document).find` *rather than* :code:`document.find` *?*

    :code:`document`, also known as :code:`window.document`, is the browser’s native representation of
    the document object. Since find is a jQuery function, we need to “wrap” document to give
    it special jQuery powers.

**Self-Check 6.6.3.** *What would happen if we omitted the last line of Figure 6.10, which arranges to call the* :code:`setup` *function?*

    The browser would behave like a legacy browser without JavaScript. The checkbox wouldn’t be drawn (since that happens in 
    the :code:`setup` function) and even if it were, nothing would happen when it was clicked, since the setup function binds our 
    JavaScript handler for the checkbox’s :code:`change` event.