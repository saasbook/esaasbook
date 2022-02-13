The Document Object Model (DOM) and jQuery
====================================

The World Wide Web Consortium Document Object Model (W3C DOM) is “a platform-and language-neutral interface 
that will allow programs and scripts to dynamically access and update the content, structure and style of 
documents”—in other words, a standard representation of an HTML, XML, or XHTML document consisting of a hierarchy 
of elements. A DOM element is recursively defined in that one of its properties is an array of child elements, as 
Figure 6.7 shows. Hence a DOM node representing the :code:`<html>` element of an HTML page is sufficient to represent the 
whole page, since every element on a well-formed page is a descendant of :code:`<html>`. Other DOM element properties 
correspond to the HTML element’s
attributes (:code:`href`, :code:`src`, and so on). When a browser loads a page, the HTML of the page is parsed into a 
DOM tree similar to Figure 6.7.

How does JavaScript get access to the DOM? When JavaScript is embedded in a browser, the global object, named by the 
global variable window, defines additional browser-specific properties and functions, collectively called the JSAPI. 
Whenever a new page is loaded, a new global :code:`window` object is created that shares no data with the global objects of 
other visible pages. One of the properties of the global object is :code:`window.document`, which is the root element of the 
current document’s DOM tree and also defines some functions to query, traverse, and modify the DOM; one of the most 
common is :code:`getElementById`, which you may have run across while perusing others’ JavaScript code.

However, to avoid compatibility problems stemming from different browsers’ implementations of the JSAPI, we will bypass 
these native JSAPI functions entirely in favor of jQuery’s more powerful “wrappers” around them. jQuery also adds additional 
features and behaviors absent from the native JSAPIs, such as animations and better support for CSS and AJAX (Section 6.7). 
jQuery defines a global function :code:`jQuery()` (aliased as :code:`$()`) that, when passed a CSS selector, returns all of the current 
page’s DOM elements matching that selector. For example, :code:`jQuery(’#movies’)` or :code:`$(’#movies’)` would return the single element 
whose ID is movies, if one exists on the page; :code:`$(’h1.title’)` would return all the :code:`h1` elements whose CSS class is :code:`title`. 
A more general version of this functionality is :code:`.find(` *selector* :code:`)`, which only searches the DOM subtree rooted at the target. 
To illustrate the distinction, :code:`$(’p span’)` finds any span element that is contained inside a p element, whereas if :code:`elt` 
already refers to a *particular* :code:`p` element, then :code:`elt.find(’span’)` only finds span elements that are descendants of :code:`elt`.


Whether you use :code:`$()` or :code:`find`, the return value is a node set (collection of one or more el- ements) matching the selector, 
or null if there were no matches. Each element is “wrapped” in jQuery’s DOM element representation, giving it abilities 
beyond the browser’s built-in JSAPI. From now on, we will refer to such elements as “jQuery-wrapped” elements, to distinguish 
them from the representation that would be returned by the browser’s native JSAPI.
In particular, you can do various things with jQuery-wrapped elements in the node set, as Figure 6.8 shows:

• To change an element’s visual appearance, define CSS classes that create the desired appearances, and use jQuery to add or remove CSS class(es) from the element at run-time.
• To change an element’s content, use jQuery functions that set the element’s HTML or plain text content.
• To animate an element (show/hide, fade in/out, and so on), invoke a jQuery function on that element that manipulates the DOM to achieve the desired effect.

Note, however, that even when a node set includes multiple matching elements, it is not a JavaScript array and you cannot 
treat it like one: you cannot write :code:`$(’tr’)[0]` to select the first row of a table, even if you first call jQuery’s :code:`toArray()` 
function on the node set. Instead, following the Iterator design pattern, jQuery provides an :code:`each` iterator defined on the 
collection that returns one element at a time while hiding the details of how the elements are stored in the collection, 
just as :code:`Array#each` does in Ruby.

Screencast 6.4.1 shows some simple examples of these behaviors from the browser’s JavaScript console. We will use these 
to implement the features of Screencast 6.1.1.

Finally, as we will see, the jQuery() or $() function is overloaded: its behavior depends on the number and types of 
arguments with which it’s called. In this section we introduced just one of its four behaviors, namely for selecting 
elements in the DOM; we will soon see the others.

**Self-Check 6.4.1.** *Why is* :code:`this.document` *, when it appears outside the scope of any function, 
equivalent to* :code:`window.document` *?*

    Outside of any function, the value of this is the global object. When JavaScript runs in a Web browser, 
    the global object is the window object.

**Self-Check 6.4.2.** *True or false: even after the user closes a window in her Web browser, the JavaScript code 
associated with that window can still access and traverse the HTML docu- ment the window had been displaying.*

    False. Each new HTML document gets its own global object and DOM, which are destroyed when the 
    document’s window is closed.