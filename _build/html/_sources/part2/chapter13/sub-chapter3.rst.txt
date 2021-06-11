Essential Readings
====================================
Software tools change rapidly: languages and frameworks go in and out of vogue every 
few years. Software engineering methodologies change over time as well: Agile wasn’t 
the first methodology and won’t be the last, and variations of Agile continue to evolve. 
It may therefore seem perilous to recommend a list of readings that *all* aspiring software 
engineers should read, much less a list of online sources. Nonetheless, some of the field’s 
bedrock ideas and acquired wisdom have stood the test of time, and we believe all software 
engineers would benefit by reading them. With some trepidation, we offer suggestions here, 
and we hasten to add that we have *no formal or financial connection* to any of these works, 
save that in some cases we have professional or academic relationships with some of the authors.

**Software design and architecture.** We have mentioned Unix numerous times in this book; it is 
arguably the most influential production operating system ever created. While many of our 
readers were probably first exposed to it as Linux, that is only the latest and most widely 
adopted implementation of the original **kernel** or “core” of Unix, which chose and refined some 
of the best ideas from pioneering experimental systems such as **Multics** while greatly simplifying 
and streamlining other aspects of it. Indeed, whereas Multics was an acronym for Multiplexed 
Information and Computing Service, with Multiplexed indicating that it was designed to serve 
multiple users simultaneously, the designers of the original Unix joked that their much smaller 
operating system might only be suitable for a single user at a time. They named it Unics, which 
was later shortened to Unix. The structure of Unix, and its approach to program design and to 
the management of processes and machine resources, are pervasive. We can suggest no better book 
than the one written by two of its designers: *The Unix Programming Environment* by Brian Kernighan 
and Rob Pike. Even many non-Unix operating systems borrow heavily from Unix’s models of process 
and resource management, and from a practical perspective, strong Unix toolsmithing skills can 
be vital when you need to quickly produce some shell scripts to automate an otherwise tedious task.

**Software project management.** When Turing Award winner Frederick P. Brooks Jr. wrote *The Mythical 
Man-Month* Brooks 1995, there was no such thing as “the software in- dustry.” Software was 
generally written by programmers working for the companies that made the hardware, but the 
processes for estimating effort, coordinating the work of multi- ple team members, and performing 
quality control were far less evolved than they were for hardware design, which had a 
multiple-decade head start. Brooks’s account of managing the OS/360 project—the operating system 
for the groundbreaking IBM System/360, and far and away the most complex piece of commercial 
software ever written up to that time—still holds valuable lessons for software project 
management, even if the economics of the industry have changed.

If OS/360 was the face of software development in the 1960s, then collaboratively-authored 
open-source development, exemplified by projects such as Linux, can be said to
be at least part of the face of software development today. Developer Eric S. Raymond’s *The 
Cathedral and the Bazaar Raymond* 2001 (also available to read for free online), while not 
uncontroversial, is a good starting point for understanding how collaborative open-source 
development came about and how it compares to traditional in-house closed-source (proprietary) 
development. As of this writing, both models are vital to the software industry, with some 
companies embracing both. For example, Facebook and Twitter do not generally release the 
source code to their products, but they have released open-source tools such as React and 
Bootstrap originally developed for internal use.

**The history of software.** The evolution suggested above—from 100%-proprietary early software to 
shrink-wrapped software sold to consumers and now to SaaS—is beautifully described in Martin 
Campbell-Kelly’s *From Airline Reservations to Sonic the Hedgehog: A History of the Software 
Industry* Campbell-Kelly 2003. For those interested in the corresponding history of hardware 
and the computing field generally, Paul Ceruzzi’s *A History of Modern Computing* Ceruzzi 2003 
(or, for the impatient, the much shorter and less detailed Computing: *A Concise History* by the 
same author Ceruzzi 2012) provides an outstanding overview.

**The modern business of software.** Today, software is a business, and as Chapter 10 emphasized, 
most often a team effort. Building and running a successful software enterprise requires 
balancing technical expertise with great strategies for recruiting, hiring, team building, and 
retention. Joel Spolsky, creator of the project management tool Trello and co-creator of 
StackOverflow, for several years wrote a blog called Joel On Software, virtually every article 
of which is worth reading. You can read online for free, or purchase the two books that collect 
and organize many of the posts by topic, *Joel On Software* and *More Joel On Software Spolsky* 
2004a,b. And if you’re going to be managing software engineers (or anyone else for that matter), 
your authors have found the actionable advice in *The One Minute Manager* Blanchard and Johnson 
1982 hard to beat for clarity and conciseness.

**Software as craftsmanship.** Throughout the book we’ve affirmed the value of beautiful, 
well-tested code. Code is resistant to enhancement if it is hard to understand, poorly 
covered by tests, or both. Hence, beautiful and well-tested code is likely to have a longer 
and more useful life than enhancement-resistant code. Steve McConnell’s *Code Complete* McConnell 
1993 justifiably remains a classic on practical software construction techniques. Robert C. 
“Uncle Bob” Martin’s *Clean Code: A Handbook of Agile Software Craftsmanship* Martin 2008 is an 
excellent and more recent companion to *Code Complete* that emphasizes taking a craftsperson’s 
pride in beauty and elegance in the code you write. Both should be on every developer’s 
bookshelf. Reading and rereading these books periodically will help keep their suggestions at 
top of mind when you’re actually at work.

To recommend a particular book is not to devalue any other particular book; no list of suggested 
readings can be definitive, complete, or fully objective. Nonetheless, we believe that these 
suggested “classics of the genre,” which combine historical perspective with modern best 
practices, form a great starting point for software engineers wishing to really polish their 
skills while being fully aware of the work of the others on whose shoulders they stand.
