Three-Tier Architecture 
====================================
So far we have treated the overall SaaS server as a “black box”: whereas Chapter 3 considered 
the software architecture of SaaS and SOA generally, and Chapter 4 examined the software
architecture of SaaS applications using patterns such as Model–View–Controller, we have been 
oblivious to how the other parts of the server are organized. For example, SaaS apps use HTTP 
to communicate, yet you haven’t had to write any of the code that handles the details of such 
communication. We also have largely ignored how SaaS software components are deployed on actual 
hardware in production. While PaaS hides much of the hardware details from you, a high-level 
understanding of the hardware architecture is key to making good decisions about scalability 
in your software architecture. To that end, this section explains how SaaS servers typically 
follow a **three-tier architecture**, how the logical boundaries sepa- rating those tiers are in 
place whether you run a development server on your own computer or deploy on a public cloud 
facility such as Heroku, how the components in the three-tier architecture typically map onto 
the cloud hardware, and what the resulting implications are for scaling up a SaaS app, that is, 
allowing it to serve more and more users.

Figure 12.2 shows the canonical three-tier architecture. The *presentation* tier usually consists 
of an *HTTP server* (or simply “**Web server**”), which accepts HTTP requests from the outside world 
(i.e., users) and handles the serving of static assets such as images, stylesheets, files of 
JavaScript code, and so on.

The web server forwards requests for dynamic content to the **logic tier**, where your actual 
application runs. The application is typically supported by an **application server** whose job 
is to hide the low-level mechanics of these HTTP interactions from the app writer. We’ve been 
using the Rack application server, which ships with the Rails framework. If you were writing 
in PHP, Python, or Java, you would use an application server that handles code written in 
frameworks that use those languages, such as Django for Python or Node.js for JavaScript.

Finally, since HTTP is stateless (Chapter 3), application data that must remain stored across 
HTTP requests, such as users’ login and profile information, is stored in the **persistence tier**. 
Popular choices for the persistence tier have traditionally been databases such as the 
open-source MySQL or PostgreSQL, although prior to their proliferation, commercial databases 
such as Oracle or IBM DB2 were also popular choices.

The “tiers” in the three-tier model are logical tiers. On a site with little content and low 
traffic, the software in all three tiers might run on a single physical computer: when you run 
:code:`rails server` to do local development, the simple single-user WEBrick Web server fulfills the 
role of the presentation tier, and a single-user database called SQLite, which stores its 
information directly in files on your local computer, serves for persistence. In production, 
it’s more common for each tier to span one or more physical computers and to use highly 
specialized software. As Figure 12.2 shows, in a typical site, incoming HTTP requests are 
directed to one of several Web servers, possibly Apache or Microsoft Internet Information 
Server, either of which can be deployed on hundreds of computers efficiently serving many 
copies of the same site to millions of users. When a Web server receives a request for you 
app, it selects one of several available application servers to handle dynamic-content 
generation, allowing computers to be added or removed from each tier as needed to handle demand.

However, as the Fallacies and Pitfalls section explains, making the persistence layer 
“shared-nothing” is much more complicated. Figure 12.2 shows one approach: a **primary/replica** 
or primary/secondary configuration, used when the database is read much more frequently than 
it is written. In this approach, any replica can perform reads, only the primary can perform 
writes, and the primary updates the replicas with the results of writes as quickly as possible. 
However, in the end, this and other techniques only postpone the scaling
problem rather than solving it. As one of Heroku’s founders wrote:

    *A question I’m often asked about Heroku is: “How do you scale the SQL database?” There’s a lot 
    of things I can say about using caching, sharding, and other techniques to take load off the 
    database. But the actual answer is: we don’t. SQL databases are fundamentally non-scalable, 
    and there is no magical pixie dust that we, or anyone, can sprinkle on them to suddenly make 
    them scale.*

    —Adam Wiggins, Heroku, in 2009

**Self-Check 12.2.1.** *Explain why cloud computing might have had a lesser impact on SaaS if most 
SaaS apps didn’t follow the shared-nothing architecture.*

    Cloud computing allows easily adding and removing computers while paying only for what you use. 
    The shared-nothing architecture takes advantage of this ability to rapidly “absorb” new computers 
    into a running app and “release” them when no longer needed.

**Self-Check 12.2.2.** *Which tier(s) of three-tier SaaS apps can be scaled just by adding more 
computers and why?*

    The presentation and logic tiers, because since neither HTTP (Web) servers nor app servers 
    maintain any of the state associated with user sessions, any computer in those tiers can in 
    principle satisfy any user’s request.