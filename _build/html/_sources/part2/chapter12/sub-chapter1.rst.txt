From Development to Deployment
====================================
    *Users are a terrible thing. Systems would be infinitely more stable without them.*

    —Michael Nygard, Release It! (Nygard 2007)

The moment a SaaS app is deployed, its behavior changes because it has actual users. If it 
is a public-facing app, it is open to malicious attacks as well as accidental success, but 
even private apps such as internal billing systems must be *designed for deployability and 
monitorability* in order to ensure smooth deployment and operations. In addition, there are 
necessarily differences between the environment in which you develop and test your app and 
the environment in which it is deployed, and these differences can sometimes result in 
unexpected (and usually undesirable) changes in app behavior between development and deployment 
that your tests didn’t catch. Fortunately, as Figure 12.1 reminds us, deployment is part of 
every iteration in the Agile lifecycle—indeed, many Agile SaaS companies deploy several times 
*per day*—so you will quickly become practiced in “routine” deployments.

SaaS deployment is much easier than it used to be. Just a few years ago, SaaS developers had to 
learn quite a bit about system administration in order to manage their own production servers. 
For small sites they were typically hosted on shared Internet Service Providers (“managed-hosting 
ISP”), on virtual machines running on shared hardware (Vir- tual Private Server or VPS), or on 
one or more dedicated computers physically located at the ISP’s datacenter (“hosting service”). 
Today, the horizontal scaling enabled by cloud computing (Section 12.2) has given rise to 
companies like Heroku that provide a **Platform as a Service** (PaaS): a curated software stack 
ready for you to deploy your app, with much of the administration and scaling responsibility 
managed for you, making deployment much more developer-friendly. PaaS providers may either run 
their own datacenters or, increasingly, rely
on lower-level Infrastructure as a Service (IaaS) providers such as the Amazon public cloud, 
as Heroku does.

For early-stage and many mature SaaS apps, PaaS is now the preferred way to deploy: basic scaling 
issues and performance tuning are handled for you by professional SaaS administrators who are 
more experienced at operations than most developers. Of course, when a site becomes large enough 
or popular enough, its technical needs may outgrow what PaaS can provide, or economics may 
suggest bringing operations “in-house”, which as we will see is a major undertaking. Therefore 
one goal of this chapter is to help your app stay within the PaaS-friendly usage tier for as 
long as possible. Indeed, if your app is internally-facing, so that its maximum user base is 
bounded and it runs in a more protected and less hostile environment than public-facing apps, 
you may have the good fortune to stay in that tier in- definitely.

In general, though, performance, reliability, and security are systemwide concerns that must be 
constantly reviewed, rather than problems to be solved once and then set aside. While PaaS helps 
address some of these concerns, others must be confronted directly by the app developers, or 
PaaS cannot help you. For example, as we will see, a key to managing the growth of your app 
is controlling the demands placed on the database, which is harder to scale horizontally. One 
insight of this chapter is that the performance and security problems you face are the same 
for both small- and large-scale SaaS apps, but the solutions differ because PaaS providers 
can be very helpful in solving some of the problems, saving you the work of a custom-built 
solution.

Notwithstanding the title of this chapter, the terms **performance** and **security** are often 
overused and ill defined. Here is a more focused list of key operational criteria we 
will address.

• Responsiveness: How long do most users wait before the app delivers a useful response? (Section 12.3)
• Release management: how can you deploy or upgrade your app “in place” without reducing availability and responsiveness? (Sections 12.4 and 12.4)
• Availability: what percentage of the time is your app correctly serving requests? (Section 12.3)
• Scalability: as the number of users increases, either gradually and permanently or as a one-time surge of popularity, can your app maintain its steady-state availability and responsiveness without increasing the operational cost per user? Chapter 3 noted that three-tier SaaS apps on cloud computing have excellent *potential* horizontal scalability, but good design alone doesn’t guarantee that your app will scale (though poor design guarantees that it won’t). Caching (Section 12.6) and avoiding abuse of the database (Section 12.7) can help.
• Privacy: is important customer data accessible only to authorized parties, such as the data’s owner and perhaps the app’s administrators?
• Authentication: can the app ensure that a given user is who they claim to be, by verifying a password or using third-party authentication such as Facebook Login or OpenID in such a way that an impostor cannot successfully impersonate another user without having obtained the user’s credentials?
• Data integrity: can the app prevent customer data from being tampered with, or at least detect when tampering has occurred or data may have been compromised?

The first three items in the above list might be collectively referred to as *performance* 
*stability*, while the last three collectively address *security*, which Section 12.9 discusses.

Lastly, the opening of this section warned about unexpected problems due to differences between 
development and production environments, or a lack of so-called *development–production parity*. 
Because it is impossible to foresee and test every such possibility before deployment, the 
alternative is to make deployment itself as agile as possible by relying heavily on automation. 
If deployment of a new version of the software causes unexpected problems, how easily can you 
“roll back” to the previous version? If a schema migration or data migration causes unexpected 
problems, can you easily restore a database snapshot taken immediately before the migration was 
run? A good rule of thumb for managing your production environment is to assume that any task 
you need to do in that environment will fail the first time and will have to be repeated from 
scratch. If the task was automated, you just type one line to re-run the script. If the task 
consisted of manual steps, you must repeat the steps, which takes longer and is particularly 
error-prone when you’re operating under the psychological pressure caused by having broken the 
production server. More so than with any other aspect of SaaS, when it comes to deployment, 
*automate everything*.

**Self-Check 12.1.1.** *Which aspects of application scalability are not automatically handled 
for you in a PaaS environment?*

    If your app “outgrows” the capacity of the largest database offered by the PaaS provider, you 
    will need to manually build a solution to split it into multiple distinct databases. This task 
    is highly app-specific so PaaS providers cannot provide a generic mechanism to do it.