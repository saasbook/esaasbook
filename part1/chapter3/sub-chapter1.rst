Introduction
====================================
Every time you use a Web browser to visit a site, or use a mobile app that also makes use 
of the cloud (such as when a weather app downloads the latest weather forecasts), you are 
using a Software-as-a-Service (SaaS) *client* to make one or more *requests* of a SaaS *server*. 
SaaS based on Web protocols is the most widely deployed example of a **client-server architecture**: 
clients are programs whose specialty is asking servers for information and (usually) allowing 
the user to interact with that information, and servers are programs whose specialty is 
efficiently serving large numbers of clients simultaneously.

Modern SaaS clients can take many forms. Whether you visit Google Maps using a browser on your PC, 
a browser on a smartphone, or a smartphone native app, you’re using a SaaS client. And while the 
clients differ in how they present and let you interact with Google Maps since each is specialized 
to its task, all three are communicating with the same Google Maps SaaS service.

In contrast to the client software, which is typically a discrete app running on a single device 
such as a PC or smartphone, the “server” is in fact typically a collection of computers running 
multiple different software components (which we will meet in due time) that together comprise the 
functionality of the actual site. The way these components are dis- tributed over one or many 
computers depends on the type of hosting environment and the number of users the app must serve. 
In any case, “the server” appears as a single logical entity to the client, which can remain 
blissfully unaware of the server’s deployment topology. Indeed, you will deploy on your own 
computer a “mini-server” with just enough functionality to let one user at a time (you, the 
developer) interact with your SaaS app during development and testing.

Distinguishing clients from servers allows each type of program to be highly specialized to its task: 
the client can have a responsive and appealing user interface, while the server concentrates on efficiently 
serving many clients simultaneously. Client-server is therefore our first example of a **design pattern** — a 
reusable structure, behavior, strategy, or technique that captures a proven solution to a collection of 
similar problems by *separating the things that change from those that stay the same*. In the case of 
client-server architectures, what stays the same is the separation of concerns between the client and 
the server, despite changes across implementations of clients and servers.

Of course, client-server isn’t the only architectural pattern found in Internet-based ser- vices. In the 
**peer-to-peer architecture**, used in BitTorrent, every participant is both a client and a server—anyone can 
ask anyone else for information. In such a system where a single program must behave as both client and 
server, it’s harder to specialize the program to do either job really well. But in the early days of computing, 
client-server architectures made particularly good sense because client hardware needed to be less expensive 
than server hardware, so that one could deploy large numbers of clients served by one or a few very expensive 
servers. Today, with falling hardware costs leading to powerful smartphones and Web browsers that support 
animation and 3D effects, a better characterization might be that clients and servers are comparably complex 
but continue to be specialized for their very different roles. Indeed, we will see those distinct roles reflected 
in the design patterns that appear in client frameworks (Angular, React, and so on) vs. those that appear in server 
frameworks (Rails, Django, Node, and so on). Even terms such as “client push” reflect the built-in assumption that 
clients are distinct from servers.

Although client-server systems long predate the emergence of SaaS, the Web, or even the
Internet, because of the Web’s ubiquity we will use the term “SaaS” (software as a service) to mean “client-server systems 
built to operate using the open standards of the World Wide Web,” that is, in which Web services are accessed using the 
protocols and data formats described in this chapter, with Web sites accessed via browsers or via mobile apps being the most common examples.

**Self-Check 3.1.1.** *What is the primary difference between the roles of clients and servers in 
SaaS?*

    A SaaS client is optimized for allowing the user to interact with information, whereas a SaaS server is optimized for serving many clients simultaneously.