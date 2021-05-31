Concluding Remarks: Rails as a Service Framework
====================================

The introduction to Rails in this chapter may seem to introduce a lot of very general machinery to handle 
a fairly simple and specific task: implementing a Web-based UI to CRUD actions. However, we will see in 
Chapter 5 that this solid groundwork will position us to appreciate the more advanced mechanisms that will 
let you truly DRY out and beautify your Rails apps. For example, adapting your app into an API-based service 
or microservice is much easier if the app mostly follows the structure of a collection of resources supporting 
the CRUD actions and perhaps some others. Controller actions such as :code:`index` and :code:`show` would need few changes 
to emit a JSON representation of an object instead of displaying an HTML representation. The :code:`new` action wouldn’t 
need to be adapted at all: it’s only there so that the human user can fill in the values that will be used for 
:code:`create`, so an API wouldn’t need to provide any version of it. Similarly, in an API-based service, create and 
update could simply return a JSON representation of the created or updated object, or even the created object’s 
ID, rather than redirecting back to some other view.

Thus, as with many tools we will use in this book, the initial learning curve to do a simple task may seem a bit steep, 
but you will quickly reap the rewards by using this strong foundation to add new functionality and features quickly and 
concisely.

That said, Rails is an opinionated framework, and over the years it has been critiqued for being too large, too complex, 
and employing too much “magic” to make things work, such as
the trick of how instance variables set by controller actions are available to the view, despite the view and controller 
not sharing any ancestor class and not really being “instances” of any- thing in any meaningful way. Over the years, 
modules have been extracted from Rails, more attention has been given to making controllers API-friendly, and many parts 
of ActiveRecord have been extracted into separate modules that can be mixed in or used without ActiveRecord and even 
without Rails. In fact, Rails itself was originally extracted from a standalone app written by the consulting group 37signals.

To understand the architecture of a software system is to understand its organizing prin- ciples. In Chapter 3 we identified 
the client-server pattern and the REST API pattern as dom- inant characteristics of SaaS. In this chapter we identified 
model-view-controller and Active Record as organizational patterns within the boundary of a software artifact. Such patterns 
are a powerful way to manage complexity in large software systems; we will have much more to say about them in Chapter 11. 
For now, we observe that by choosing to build a SaaS app, we have predetermined the use of some patterns and excluded 
others. By choosing to use Web standards, we have predetermined a client-server system; by choosing cloud computing, we 
have predetermined the 3-tier architecture to permit horizontal scaling. Model–View– Controller is not predetermined, but we 
choose it because it is a good fit for Web apps that are view-centric and have historically relied on a persistence tier, 
notwithstanding other possible patterns such as those in Figure 4.1. REST is not predetermined, but we choose it because it 
simplifies integration into a Service-Oriented Architecture and can be readily applied to the CRUD operations, which are so 
common in MVC apps. Active Record is perhaps more controversial—as we will see in Sections 5.8 and 12.7, its powerful 
facilities simplify apps considerably, but misusing those facilities can lead to scalability and performance problems that 
are less likely to occur with simpler persistence models.

A good framework should also be closely wedded to the language in which it’s imple- mented: the framework should not only 
provide a well-defined abstraction for the applica- tion’s architecture, but also use the language’s features to support 
those abstractions. For example, Rails uses Ruby’s introspection and metaprogramming to provide an elegant implementation 
of both the Model–View–Controller application architecture and the Active Record design pattern for storing model data. And 
not all server-side or client-side stacks are application frameworks: while Node.js provides some low-level abstractions 
for **event-driven programming** (about which we will have much more to say in Chapter 6), it provides no abstractions for any 
particular architectural pattern on which one might want to base an application.

If we were building a SaaS app in 1995, none of the above would have been obvious because practitioners had not accumulated 
enough examples of successful SaaS apps to “extract” successful patterns into frameworks like Rails, software components 
like Apache, and middleware like Rack. By following the successful footsteps of software architects before us, we can take 
advantage of their ability to *separate the things that change from those that stay the same* across many examples of SaaS and 
provide tools, frameworks, and design principles that support building things this way. As we mentioned earlier, this 
separation is key to enabling reuse.
