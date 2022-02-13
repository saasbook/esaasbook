Fallacies and Pitfalls
====================================
**Fallacy: All the extra effort for testing very rare conditions in Continuous Integration 
tests is more trouble than it’s worth.**

At 1 million hits per day, a “rare” one-in-a-million event is statistically likely every 
day. 1 million hits per day was Slashdot’s volume in 2010. At 8 *billion* (8 × 109 ) hits per 
day, which was Facebook’s volume in 201032, 8,000 “one-in-a-million” events can be expected 
per day. This is why code reviews at companies such as Google often focus on corner cases: 
at large scale, astronomically-unlikely events happen all the time (Brewer 2012). The extra 
resilience provided by error-handling code will help you sleep better at night.

**Pitfall: Hidden assumptions that differ between development and production environments.**

Chapter 4 explains how Bundler and the Gemfile automate the management of your app’s 
dependencies on external libraries and how migrations automate making changes to your database. 
Heroku relies on these mechanisms for successful deployment of your app. If you manually install 
gems rather than listing them in your Gemfile, those gems will be missing or have the wrong 
version on Heroku. If you change your database manually rather than using migrations, Heroku 
won’t be able to make the production database match your development database. Other dependencies 
of your app include the type of database (Heroku uses Post- greSQL), the versions of Ruby and 
Rails, the specific Web server used as the presentation tier, and more. While frameworks like 
Rails and deployment platforms like Heroku go to great lengths to shield your app from variation 
in these areas, using automation tools like mi- grations and Bundler, rather than making manual 
changes to your development environment, maximizes the likelihood that you’ve documented your 
dependencies so you can keep your development and production environments in sync. If it can be 
automated and recorded in a file, it should be!

**Fallacy: We don’t have to worry about performance because 3-tier cloud apps can “magically” scale 
and cloud computing is cheap.**

If you’re using well-curated PaaS, *and* following the advice in this chapter for being kind to 
your database and leveraging caching, there is some truth to this statement up to a point. 
However, if your app “outgrows” PaaS, the fundamental problems of scalability and load 
balancing are now passed on to you. In other words, with PaaS you are not spared having to 
understand and avoid such problems, but you are *temporarily* spared from rolling your own 
solutions to them. When you start to set up your own system from scratch, it doesn’t take 
long to appreciate the value of PaaS.

In Chapter 1 we argued for trading today’s extra compute power for more productive tools and 
languages. However, it’s easy to take this argument too far. In 2008, performance engineer 
Nicole Sullivan reported on experiments conducted by various large SaaS operators about how 
additional latency affected their sites. Figure 12.15 clearly shows that when extra processor 
time becomes extra latency (and therefore reduced responsiveness) for the end user, processor 
cycles aren’t free at all.

**Fallacy: The app is still in development, so we can ignore performance.**

Knuth has said that premature optimization is the root of all evil “... about 97% of the time.” 
But the quote continues: “Yet we should not pass up our opportunities in that critical 3%.” 
Blindly ignoring design issues such as lack of indices or needless repeated queries at design 
time is just as bad as focusing myopically on performance at design time. Being alert
for, and avoiding, truly egregious performance mistakes will enable you to steer a happy 
path between two extremes.

**Pitfall: Optimizing without measuring.**

Some customers are surprised that Heroku doesn’t automatically add Web server capacity when 
a customer app is slow (van Hardenberg 2012). The reason is that without instrumenting and 
measuring your app, you don’t know *why* it’s slow, and the risk is that adding Web servers 
will make the problem worse. For example, if your app suffers from a database problem such as 
lack of indices or :math:`n+1` queries, or if relies on a separate service like Google Maps that is 
temporarily slow, adding servers to accept requests from *more* users will only make things worse. 
Without measuring, you won’t know what to fix.

**Pitfall: Abusing continuous deployment, leading to cruft accumulation.**

As we have already seen, evolving apps may grow to a point where a design change or 
architectural change would be the cleanest way to support new functionality. Since continuous 
deployment focuses on small incremental steps and tells us to avoid worrying about any 
functionality we don’t need immediately, the app has the potential to accumulate a lot of **cruft** 
as more code is bolted onto an obsolete design. The increasing presence of code smells 
(Chapter 9) is often an early symptom of this pitfall, which can be avoided by periodic design 
and architecture reviews when smells start to creep in.

**Pitfall: Bugs in naming or expiration logic, leading to silently-wrong caching behavior.**

As we noted, the two problems you must tackle with any kind of caching are naming and expiration. 
If you inadvertently reuse the same name for different objects—for example, a non-RESTful action 
that delivers different content depending on the logged-in user, but is always named using the 
same URI—then a cached object will be erroneously served when it shouldn’t be. If your sweepers 
don’t capture all the conditions under which a set of cached objects could become invalid, users 
could see stale data that doesn’t reflect the results of recent changes, such as a movie list 
that doesn’t contain the most recently added movies. Unit tests should cover such cases 
(“Caching system when new movie is added should immediately reflect new movie on the home page 
list”). Follow the steps in the Rails Caching Guide to turn on caching in the testing and 
development environments, where it’s off by default to simplify debugging.

**Pitfall: Slow external servers in an SOA that can adversely affect your own app’s performance.**

If your app communicates with external servers in an SOA, you should be prepared for the 
possibility that those external servers are slow or unresponsive. The easy case is handling 
an unresponsive server, since a refused HTTP connection will result in a Ruby exception that 
you can catch. The hard case is a server that is functioning but very slow: by default, the 
call to the server will block (wait until the operation is complete or the TCP “slow timeout” 
expires, which can take up to three minutes), making *your* app slow down as well. Even worse, 
since most Rails front ends (:code:`thin, webrick, mongrel`) are single-threaded, if you are running 
:math:`N` such front-ends (“dynos” in Heroku’s terminology) it takes only :math:`N` simultaneous 
requests to hang your application completely. The solution is to use Ruby’s :code:`timeout` library 
to “protect” the call, as the code in Figure 12.16 shows.

.. code-block:: ruby

    require 'timeout'
    # call external service, but abort if no answer in 3 seconds:
    Timeout :: timeout (3.0) do 
        begin
            # potentially slow operation here
        rescue Timeout::Error
            # what to do if timeout occurs
        end 
    end

**Fallacy: My app is secure because it runs on a secure platform and uses firewalls and HTTPS.**

There’s no such thing as a “secure platform.” There are certainly *insecure* platforms, but no 
platform by itself can assure the security of your app. Security is a systemwide and ongoing 
concern: Every system has a weakest link, and as new exploits and software bugs are found, 
the weakest link may move from one part of the system to the other. The “arms race” between 
evildoers and legitimate developers makes it increasingly compelling to use professionally-curated 
PaaS infrastructure, so you can focus on securing your app code.

**Fallacy: My app isn’t a target for attackers because it serves a niche audience, experiences 
low volume, and doesn’t store valuable information.**

Malicious attackers aren’t necessarily after your app; they may be seeking to compromise 
it as a vehicle to a further end. For example, if your app accepts blog-style comments, it 
will become the target of blog spam, in which automated agents (bots) post spammy comments 
containing links the spammer hopes users will follow, either to buy something or cause malware 
to be installed. If your app is open to SQL injection attacks, one motive for such an attack 
might be to influence the code that is displayed by your views so as to incorporate a 
cross-site scripting attack, for example to cause malware to be downloaded onto an unsuspecting 
user’s machine. Even without malicious attackers, if any aspect of your app goes “viral” and 
becomes suddenly popular, you’ll be suddenly inundated with traffic. The lesson is: *If your 
app is publicly deployed, it is a target.*

**Fallacy: Rails doesn’t scale (or Django, or PHP, or other frameworks).**

With the shared-nothing 3-tier architecture depicted in Figure 12.2, the Web server and
app server tiers (where Rails apps would run) can be scaled almost arbitrarily far by adding 
computers in each tier using cloud computing. The challenge lies in scaling the database, 
as the next Pitfall explains.

**Pitfall: Putting all model data in an RDBMS on a single server computer, 
thereby limiting scalability.**

The power of RDBMSs is a double-edged sword. It’s easy to create database structures prone 
to scalability problems that might not emerge until a service grows to hundreds of thousands 
of users. Some developers feel that Rails compounds this problem because its Model 
abstractions are so productive that it is tempting to use them without thinking of the 
scalability consequences. Unfortunately, unlike with the Web server and app tiers, we 
cannot “scale our way out” of this problem by simply deploying many copies of the database 
because this might result in different values for different copies of the same item (the 
**data consistency** problem). Although techniques such as primary/replica and database **sharding** 
help make the database tier more like the shared-nothing presentation and logic tiers, 
extreme database scalability remains an area of both research and engineering effort.

**Pitfall: Prematurely focusing on per-computer performance of your SaaS app.**

Although the shared-nothing architecture makes horizontal scaling easy, we still need 
physical computers to do it. Adding a computer used to be expensive (buy the computer), 
time-consuming (configure and install the computer), and permanent (if demand subsides later, 
you’ll be paying for an idle computer). With cloud computing, all three problems are 
alleviated, since we can add computers instantly for pennies per hour and release them when 
we don’t need them anymore. Hence, until a SaaS app becomes large enough to require hundreds 
of computers, SaaS developers should focus on *horizontal scalability* rather than per-computer 
performance.