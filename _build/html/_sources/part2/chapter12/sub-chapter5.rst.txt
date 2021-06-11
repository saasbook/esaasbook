Monitoring and Finding Bottlenecks
====================================
    *If you’re not monitoring it, it’s probably broken.*

    —variously attributed

Given the importance of responsiveness and availability, how can we measure them, and if 
they’re unsatisfactory, how can we identify what parts of our app need attention? *Monitoring* 
consists of collecting app performance data for analysis and visualization. In the case of 
SaaS, application performance monitoring (APM) refers to monitoring the Key Performance 
Indicators (KPIs) that *directly impact business value*. KPIs are by nature app-specific—for 
example, an e-tailer’s KPIs might include responsiveness of adding an item to a shopping 
cart and percentage of user searches in which the user selects an item that is in the top 
5 search results.

There are various techniques for monitoring SaaS apps, and we can characterize them in 
terms of three axes:

1. Is the monitoring active or passive? In active monitoring, an external stimulus is deliberately applied to the app (even if the app would be otherwise idle) in order to ensure it’s working. In passive monitoring, no monitoring data is collected until some external user asks the app to do something.
2. Is the monitoring external or internal? External monitoring can only report on the behavior of an app as seen from the outside—for example, reporting that some types of requests take longer than other types. Internal monitoring can “hook” into the code of the app server or the app itself, so it can provide better *attribution*—how long did a request spend in each tier of the SaaS stack and in different parts of your app (for example, the controllers, the models, the database, or the view rendering)?
3. Is the monitoring focused on app performance or user behavior? For example, you might want to know what fraction of users who added an item to their shopping cart ended up purchasing the item, and what actions were taken instead by the users who didn’t end up completing the purchase. Such questions can be critical for a business even though they have little do with performance. (Of course, performance monitoring might reveal the *reasons* some users don’t complete the purchase flow!)

Regardless of which combination of the above axes is provided by a particular monitoring 
solution, we must also address the issue of how the collected monitoring data is stored 
and how it is presented or reported to the app’s dev/ops team.

Before cloud computing and the prominence of SaaS and highly-productive frameworks, internal 
monitoring required installing programs that collected metrics periodically, manually inserting 
extra code into your app, or both. Today, the combination of hosted PaaS, Ruby’s dynamic 
language features, and well-factored frameworks such as Rails allows internal monitoring without 
modifying your app’s source code or installing software. For example, New Relic unobtrusively 
collects instrumentation about your app’s controller actions, database queries, and so on, 
making use of metaprogramming in Rails to do this without requiring changes to your app’s code. 
Because the data is sent back to New Relic’s SaaS site where you can view and analyze it, this 
architecture is sometimes called RPM for Remote Perfor- mance Monitoring. New Relic provides 
both internal passive monitoring and external active monitoring, in which you can set up HTTP 
“probe” requests with fixed URIs and test for the presence of particular strings in the apps’ 
responses.

Internal monitoring can also occur during development, when it is often called **profiling**. New 
Relic and other monitoring solutions can be installed in development mode as well. How much 
profiling should you do? If you’ve followed best practices in writing and testing your app, 
it may be most productive to just deploy and see how the app behaves under load, especially 
given the unavoidable differences between the development and production environments, such 
as the lack of real user activity and the use of a development-only database such as SQLite 
rather than a highly tuned production database such as PostgreSQL. After all, with agile 
development, it’s easy to deploy incremental fixes such as implementing basic caching (Section 
12.6) and fixing abuses of the database (Sections 12.7).

In external monitoring (sometimes called probing or active monitoring), a separate site makes 
live requests to your app to check availability and response time. Why would you need external 
monitoring given the detailed information available from internal monitoring that has access 
to your code? Internal monitoring may be unable to reveal that your app is sluggish or 
unavailable if the problem is due to factors other than your app’s code—for example, performance 
problems in the presentation tier or other parts of the software stack beyond your app’s 
boundaries. External monitoring, like an integration test, is a true end- to-end test of a 
limited subset of your app’s code paths as seen by actual users “from the outside.”

Once a monitoring tool has identified the slowest or most expensive requests, **stress testing** 
or longevity testing on a staging server can quantify the level of demand at which those 
requests become bottlenecks. The free and widely-used command line tool **httperf**, maintained 
by Hewlett-Packard Laboratories, can simulate a specified number of users requesting simple 
sequences of URIs from an app and recording metrics about the response times. Whereas tools 
like Cucumber let you write expressive scenarios and check arbitrarily complex conditions, 
:code:`httperf` can only follow simple sequences of URIs and only checks whether a successful HTTP 
response was received from the server. In a typical stress test,
he test engineer will set up several computers running :code:`httperf` against the staging site and 
gradually increase the number of simulated users until some resource becomes the bottleneck.

Finally, monitoring can also help you understand your customers’ behavior:

• Clickstreams: what are the most popular sequences of pages your users visit?
• Think times/dwell times: how long does a typical user stay on a given page?
• Abandonment: if your site contains a flow that has a well-defined termination, such as making a sale, what percentage of users “abandon” the flow rather than completing it and how far do they get?

Google Analytics provides free basic analytics-as-a-service: you embed a small piece of 
JavaScript in every page on your site (for example, by embedding it on the default layout 
template) that sends Google Analytics information each time a page is loaded. To help you use 
this information, Google’s “Speed is a Feature”12 site links to a breathtakingly comprehensive 
collection of articles about all the different ways you can speed up your SaaS apps, including 
many optimizations to reduce the overall size of your pages and improve the speed at which Web 
browsers can render them.

**Self-Check 12.5.1.** *Which of the following key performance indicators (KPIs) would be 
relevant for Application Performance Monitoring: CPU utilization of a particular computer; 
completion time of slow database queries; view rendering time of 5 slowest views.*

    Query completion times and view rendering times are relevant because they have a direct 
    impact on responsiveness, which is generally a Key Performance Indicator tied to business 
    value delivered to the customer. CPU utilization, while useful to know, does not directly 
    tell us about the customer experience.