Preface
====================================
*If you want to build a ship, don’t drum up the men to gather wood,
divide the work and give orders. Instead, teach them to yearn for
the vast and endless sea.*

                        —Antoine de Saint-Exupéry, Citadelle, 1948

*If you’re nostalgic for the Welcome from the First Edition, 
you can read it at http://www.saasbook.info/welcome-1st-edition1*

We created the First Edition of ESaaS in 2014 to help other instructors 
and students of software engineering practice what we had discovered: 
Agile+SaaS is not just a great way to develop and deploy software, 
it’s also a great fit for teaching software engineering. We have been 
humbled by the success of the book, the accompanying instructor materials 
(for which visit saasbook.info), and the Massive Open Online Courses on 
edX as a way of “spreading the word!”

A core concept of software design from the First Edition was “Separate the 
things that change from those that stay the same.” To that end, a Second Edition 
coming more than five years after the First Edition—an eternity in the software 
world—really made us think about how to achieve that separation. The most noticeable 
structural and content changes are as follows:

**COD** and **CHIPS.** There is much cleaner separation of Content-Oriented Didactics 
(COD) from Coding/Hands-on Integrated Programming activities (CHIPS). Most of the book’s 
sections are COD: we present the conceptual vocabulary that shows the learner *how to think about* 
an important idea. Interspersed after every few COD sections are CHIPS, where students learn by doing, 
applying the ideas of the previous sections in a hands-on exercises.

One area where the COD and CHIPS separation is incomplete is in the coverage of JavaScript. Something 
that has *not* changed is that despite the proliferation of JavaScript frameworks, including many that 
barely existed when the First Edition was released (An- gular, Bootstrap, Vue, Express, React...), 
JavaScript continues to bring unique debugging and programming challenges that do not always appear 
to be as well supported by tools as Ruby and Rails. That material is still evolving and new CHIPS will be 
forthcoming to further disentangle the code from the COD. (Sorry.)

**All-in-one course using Codio.** We have worked closely with Codio to integrate COD, CHIPS, and autograding 
into their education-focused IDE. Our pioneering autograders were getting long in the tooth and overdue for 
retirement. We strongly urge instructors or students to use Codio to get started as quickly as possible, but 
for instructors or students not using Codio, Gradescope-compatible autograder files are also available.

**Mobile-first, API-first exposition of SaaS.** Since the First Edition, “cloud + client” has remained the 
dominant way that software is developed, but SaaS has transitioned from deliv- ering primarily HTML views 
to delivering data to mobile clients over APIs. As well, much greater attention is being paid to designing 
for persons with disabilities. We therefore imme- diately motivate the use of a resource-based, API-centric 
approach to thinking about server design, and the use of mobile-first and mobile-friendly frameworks based on 
open standars, such as Bootstrap, for the client side. The new “API first” exposition should empower learners 
to think about resource-centric design of their apps and how a RESTful API exposes those resources to a client, 
and then transfer this thinking to the development of native mobile apps.

**From “learning Ruby and Rails” to “learning a language and framework.”** One unfortunate thing that has not changed 
is that software engineering education still has no credentials defined around specific skill sets; for-profit boot 
camps have stepped into the vac- uum, with varying results. This book and its accompanying materials aren’t a bootcamp: 
our goal is to convey the successful ideas that underpin the design of the frameworks used today and those yet to be 
invented by our readers. To that end, our expositions of Ruby, Rails, and JavaScript now suggest a more general strategy 
for learning new languages and frameworks rapidly, and on understanding the relationship between a framework and the 
language features that support the framework’s abstractions. And since Python has definitively displaced Java as the 
most widely used fully-featured introductory programming language, these expositions are now aimed at learners familiar 
with Python.

Finally, our students at Berkeley frequently ask “Will this course teach me to use *X*?” or “Why does this course teach *X* 
instead of *Y*?” A popular instance of this question in 2019 is “Why does this course use Ruby/Rails, JavaScript, and relational 
databases, rather than Python/Django (or Node), Android/React, and MongoDB?” Our answer has not changed since the First Edition. 
The software ecosystem evolves so rapidly that at any given time you will have many frameworks and tools from which to choose. 
Since our choices won’t please everyone and will probably be outdated in a few years anyway, we still choose the tools that best 
support our pedagogical goal of teaching a particular methodology for developing great software.

Some acknowledgments are in order, as it truly takes a village to create and maintain a good set of course materials. Beyond the 
people we thanked in the First Edition, the following colleagues were particularly helpful in reviewing the Second Edition changes: 
Prof. Kristin Stephens-Martinez, Duke University (Chapter 1); Prof. Mark Smucker, University of Waterloo (Chapter 2); Blagovesta Kostova, 
EPFL (Chapter 3); Prof. Michael Verdicchio, The Citadel Military College of South Carolina (Chapter 4); Lic. Matías Mascazzini, independent 
Rails developer (Chapter 5); Prof. Tom Hastings, University of Colorado at Colorado Springs (Chapter 6); Prof. Hank Walker, Texas A&M 
University (Chapters 7 and 8); Prof. Prabhat Vaish, New Jersey Institute of Technology (Chapter 9); Prof. Anastasia Kurdia, Tulane University 
(Chapter 10); Prof. Ed Gehringer, North Carolina State University (Chapter 11); and Prof. Daniel Cordeiro, Universidade de São Paulo (Chapter 12).

As always, the core members of the “Beta Gold” group, formed way back in the days of the First Edition, have stuck with us and proactively 
helped improve the course in ways too numerous to mention that benefit everyone who uses the materials: Michael and Hank from the list above, 
plus Rose Williams, Binghamton University, and Kristen Walcott-Justice, University of Colorado at Colorado Springs.

Our colleagues at GitHub, and particularly Director of Developer Education Vanessa Gennarelli (@mozzadrella), continue to be more generous 
and supportive of our education efforts than we have any right to expect.

The Codio team, especially our developer liaison Elise Deitrick, has done phenomenal work in beautifully integrating both the book and exercises 
into the Codio platform, providing a one-stop shop for instructors and students wanting to get started quickly.

Finally, as always, we thank the thousands of UC Berkeley students and the hundreds of thousands of MOOC students for their debugging help and their 
continuing interest in this material!