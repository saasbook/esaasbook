Fallacies and Pitfalls
====================================

**Fallacy: Splitting a large “monolithic” service into many microservices decreases complexity.**


The complexity of a system’s application logic does not disappear from splitting it or designing it to be service-oriented; 
the complexity is simply distributed among the microser- vices, and in particular, how the interaction among those microservices 
is managed. The two main structural patterns for coordination among microservices are orchestration (the com- position layer has 
a higher level of complexity and holds more of the application’s logic) and choreography (the services interact among themselves 
without a separate composition layer). Finally, splitting a large service into microservices requires thinking about module
boundaries just as one would in designing a large service in the first place.

**Fallacy: Publishing my API makes my service RESTful (or makes it a mi- croservice, or SOA-friendly, and so on).**

A published API just means that external calls are allowed; the API’s understandability and usability will determine whether the 
API or service is widely adopted, since the API defines the boundary negotiation for what the service will do (expected output) 
and how the caller will access it (expected output). REST is not the only good way to design an API, but there are certainly many 
bad ways to design an API, and carefully following REST makes it less likely you’ll accidentally choose one of those ways.

**Fallacy: I haven’t published an API, so clients cannot call my app.**

Every publicly-accessible website already has a de facto HTTP API, because URIs can be constructed to interact with the site. 
Of course, such an “accidental” API will rarely adhere to good design practices; a client wishing to use it might have to 
(for example) pick apart a returned HTML page to extract the information it wants, a process sometimes called HTML scraping. 
Nonetheless, if your app is publicly available, it has an API whether you intended it or not. If you do intend for your app to 
be used programmatically as a service or microservice, you should design and expose an API according to the guidelines in this chapter.

**Pitfall: Thinking in terms of URIs, user actions, and views instead of thinking in terms of resources.**

Consider a sequence of steps for a hypothetical e-commerce site: in step 1, a user visits a product page; in step 2, they add a 
product to a shopping cart; perhaps they repeat steps 1 and 2 to add multiple products; and in step 3, they pay for the product(s). 
If you design the business logic for such an app from a "Web-page-centric" point of view, you might be tempted to simply keep track 
of which step the user is on (say, as part of the session or by including the step number as a parameter in a URL) and include 
logic that dispatches to the appropriate internal action for each step. But such a design approach doesn’t force you to think about 
important questions such as: If the user leaves the site and returns later, how can we ensure their cart contents haven’t changed? 
If the user abandons the order without paying, at what point do we decide to delete it? If the payment step fails, can we easily 
direct the user to re-try only that step without going through all the previous steps again? In contrast, a RESTful API design 
approach would begin by asking: What kind of resource is an order, and what operations are available on it? What kind of resource 
is a product, and what operations are available on it? What can go wrong during each type of operation? How is each kind of resource 
stored on the server, and under what conditions can it be deleted? How does the client refer to a particular resource that was created 
earlier, even if the user has been away from the keyboard for a long time? Thoughtful answers to such questions result in a clean service 
design that is suitable for use both as a standalone (micro)service and the back end of a browser-based experience.

**Pitfall: Poor design of API resulting from misunderstanding of the domain or of the customers’ use cases.**

We noted that the TMDb API call for “get reviews associated with this movie” actually returns the reviews’ contents, not just their IDs. 
This design makes sense if most request of this type are intending to inspect the content of most of the reviews. But if the more common 
use case was (for example) to allow an end user to display details of reviews with particular characteristics such as numerical rating, 
a leaner API might allow specifying those options to constrain the result.

In general, insufficient understanding of how customers will use your API may lead to inefficient resource representation internally, 
but as we will see, the good news is that the internal representation of resources can be changed later as long as the details of that 
representation haven’t leaked into API.