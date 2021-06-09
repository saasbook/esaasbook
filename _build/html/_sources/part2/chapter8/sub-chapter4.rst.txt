Stubbing the Internet 
====================================

When testing a method that makes a call to an external service via an API, 
there are many reasons we almost certainly *don’t* want to make a real call 
to that API. One reason is abuse of the service’s terms. Several years ago, 
the CS department head at a major US university received a complaint from 
a web site that hosted academic papers, because a group of students had been 
working on a student project that repeatedly made “test” API calls against 
the real site. The site threatened to cut off the university’s access if 
the students continued this behavior. Another reason is that making real 
calls might prevent the test from being **R**\epeatable depending on how the remote 
service responds, and would almost certainly prevent the test from being **F**\ast.

In fact, when testing our own app, all that we really care about is whether the API 
calls it *would* make are correctly formed—analogously to checking a call to a method 
stub to make sure the arguments are correct. So the more general question is: Where 
should we stub external methods when testing an app that makes calls to an external 
service? In Figure 8.5 we chose to stub the model and mimic the results of the gem’s 
calls to TMDb, but a more robust integration testing approach would instead place the 
stub “closer” to the remote service. In particular, we could create fixtures—files 
containing the JSON content returned by actual calls to the service—and arrange to 
intercept calls to the remote service and return the contents of those fixture files 
instead. The Webmock gem does exactly this: it stubs out the entire Web except for 
particular URIs that return a canned response when accessed from
a Ruby program. (You can think of Webmock as :code:`allow(...).to receive(...).and_return` for the whole Web.) 
There’s even a companion gem VCR that automates getting a response from the real service, 
saving the response data in a fixture file, and then “replaying” the fixture when your tests 
cause the remote service to be “called” by intercepting low-level calls in the Ruby HTTP library.

From an integration-testing standpoint, Webmock is the most realistic way to test interactions 
with a remote service, because the stubbed behavior is “farthest away”—we are stubbing as late 
as possible in the flow of the request. Therefore, when creating Cucumber scenarios to test 
external service integration, Webmock is usually the appropriate choice. From a unit testing 
point of view (as we’ve adopted in this chapter) it’s less compelling, since we are concerned 
with the correct behavior of specific class methods, and we don’t mind stubbing “close by” in 
order to observe those behaviors in a controlled environment.

**Self-Check 8.4.1.** *Is “stubbing the Internet” in conflict with the advice of Chapter 7 
that one should avoid mocks or stubs in full-system Cucumber scenarios?*

    Full-system testing should avoid “faking” certain parts of it as we have done using 
    seams in most of this chapter. However, if the “full system” includes interacting with 
    outside services we don’t control, such as the interaction with TMDb in this example, 
    we do need a way to “fake” their behavior for testing.