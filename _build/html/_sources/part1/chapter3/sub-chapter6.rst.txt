RESTful URIs, API Calls, and JSON
====================================

In considering how to treat a collection of SOA servers as a fabric for programming, we’ve addressed rows 1–3 of Figure 3.5. 
We next describe how data is passed to or received from such services, and some operational considerations such as authorization 
(is the client allowed to make this API call on this resource?) and how errors are handled.


At the highest level, there are three ways to pass parameters *from* an HTTP client *to* a service: in the URI, in the request body 
(for :code:`POST` or :code:`PUT` requests), and rarely, as the value of an HTTP header.

When the number of parameters is small, and in particular when the parameters are sim- ple types such as strings or numbers, they can 
often be passed as parameters embedded in the URI, as Figure 3.2 showed: :code:`param1=value1&param2=value2&...&paramN=valueN`. This situation 
is typical for :code:`GET` requests, where we’re usually asking for data based on an ID and perhaps some optional parameters. For example, 
verify using the TMDb API documentation that the route :code:`GET /search/movies?query=Batman+Returns` will search TMDb for a movie whose 
title matches the query string “Batman Returns”.

When the data to be passed is more complex, or when the API operation involves a state-changing HTTP method such as :code:`POST` or :code:`PUT`, the data is 
sent as part of the request body, as browsers do when submitting the values entered on a fill-in form. (Recall that GET requests have no 
request body.) How is this data presented to the server? While there are many choices, there is no question that the SOA community has rapidly 
converged on **JSON** (pronounced “JAY-sahn”), or JavaScript Object Notation, as the common interchange for- mat. JSON is so called because its syntax 
resembles, but is not identical to, the syntax of a JavaScript object literal—a set of unordered key/value pairs, like a Ruby hash, Python dict, 
or Java HashMap) of key/value pairs. In JSON, each key (or “slot,” as we’ll learn in Chapter 6) must be a double-quoted string, and its value may 
be a simple type (string, numeric, :code:`true, false, null`), another object, or a linear array each of whose elements can be any of these, including another 
array. The JSON web site shows some simple examples, and because of JSON’s popularity as the default data format for SOA, virtually every modern language 
comes with libraries to both generate and parse JSON. Blank space (spaces,
tabs, newlines) is optional in JSON, and most servers return blankspace-free JSON. Unix command-line tools such as :code:`json_pp` and browser extensions like JSONView 
restore spacing and indentation to make JSON more readable. Note that calls that require sending JSON data may *also* allow (or require) sending some parameter 
values encoded in the URI; you must check the API documentation for details.

.. code-block:: ruby

    # set endpoint for TMDb API
    export BASE=https://api.themoviedb.org/v3
    # set our API key for use in other calls
    export KEY="my API key here"
    # Search for a movie by keywords
    curl "$BASE/search/movie?api_key=$KEY&query=Batman+Returns"
    # For better legibility, pipe the output to json_pp:
    curl "$BASE/search/movie?api_key=$KEY&query=Batman+Returns" | json_pp
    # Start a new guest session
    curl "$BASE/authentication/guest_session/new" | json_pp
    # capture the guest session ID from Curl's output:
    export SESSION=e91f07cca8166b7b1e707d8a826e8a38
    # Create a file containing  the JSON object for rating a movie:
    echo '{ "rating": 6.5 }'  > myrating.json
    # Use Curl to POST a movie rating request using the file's contents:
    curl -X POST -H "Content-Type: application/json" -d @myrating.json \
    "$BASE/movie/364/rating?api_key=$KEY&guest_session_id=$SESSION"

HTTP headers are sometimes used to pass very specialized types of parameters. For example, some APIs require you to add the HTTP header Content-Type: :code:`application/json` 
to a request that will be accompanied by a JSON payload, while others don’t. Finally, nearly all APIs require authorization—the client must prove it has the right to make 
each API call. While authorization schemes vary, the mostcommonistoincludeaclient-specificAPIkeywitheachrequest. APIkeysareusually requested manually and may be free or 
paid (TMDb’s are free), and the service may impose limits such as the number of calls made per day. Depending on the API, the key may be sent as an argument in the URI 
(as with TMDb), as the value of an HTTP :code:`Authorization`: header, or either.

Putting this all together, Figure 3.7 shows the use of the curl tool to do a sequence of RESTful API requests—all but the last are :code:`GET`s—exercising the TMDb API. Note in 
particular that the API key is a required URI parameter for every request, and verify against the API documentation the correct format for the object in line 14 representing 
the desired rating you wish to submit for a movie.

What if an error occurs? Recall from Section 3.2 that every HTTP response begins with a 3-digit status code; these are cataloged and maintained7 by the World Wide Web Consortium. 
Services use status codes to indicate various types of errors:

• 2xx codes indicate success. For example, code 200 (“OK”) would be the usual success status for a :code:`GET`, whereas code 201 (“Created”) would be more typical for a :code:`POST` that creates a new resource.
• 3xx codes indicate the client must take further action to complete the request—that is, a redirect. Perhaps the requested resource has moved to a different URI, which would be specified in the response body.
• 4xx codes indicate that the service encountered an application error processing the request. 400 means the request was malformed, but other codes for well-formed requests include 401 (Unauthorized), 402 (Payment required), and others.
• 5xx codes indicate a problem with the service infrastructure itself—an error that prevented the remote call from even completing, such as the server encountering an internal error so severe that it is too broken to even explain what went wrong.

In case of an error (any status other than 2xx), the response body usually contains a message explaining what went wrong. Depending on the API, the response body may consist simply 
of this string, or it may be a JSON object with a single string-valued slot named message or error or something similar.

**Self-Check 3.6.1.** *You try an API call on TMDb and the status code of the response is 400. Assuming TMDb adheres to the official W3C semantics of the status codes, 
which of the following could be the reason for the error: (a) your request was malformed so could not be attempted; (b) you forgot to include your API key; (c) 
your request and API key were well-formed, but you are attempting an operation that you’re not authorized to do.*

    **(a)** is most likely. 401 :code:`Unauthorized` would be more likely for the other two cases.