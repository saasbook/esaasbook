Introduction
====================================
*Now, this is real simple. It’s a website where you can compare and purchase affordable 
health insurance plans, side-by-side, the same way you shop for a plane ticket on Kayak 
or the same way you shop for a TV on Amazon. . . Starting on Tuesday, every American can 
visit HealthCare.gov to find out what’s called the insurance marketplace...So tell your 
friends, tell your family... Make sure they sign up. Let’s help our fellow Americans get 
covered. (Applause.)*
                —President Barack Obama, Remarks on the Affordable Care Act, Prince George’s Community College, Maryland, September 26, 2013

*... it has now been six weeks since the Affordable Care Act’s new marketplaces opened for business. 
I think it’s fair to say that the rollout has been rough so far, and I think everybody understands 
that I’m not happy about the fact that the rollout has been, you know, fraught with a whole range of 
problems that I’ve been deeply concerned about.*
                —President Barack Obama, Statement on the Affordable Care Act, The White House Press Briefing Room, November 14, 2013

When the *Affordable Care Act (ACA)* was passed in 2010, it was seen as the most ambitious US social program 
in decades, and it was perhaps the crowning achievement of the Obama administration. Just as millions shop 
for items on Amazon.com, HealthCare.gov— also known as the Affordable Care Act website—was supposed to let 
millions of uninsured Americans shop for insurance policies. Despite taking three years to build, it fell 
flat on its face when it debuted on October 1, 2013. Figure 1.1 compares Amazon.com to Healthcare.gov in the 
first three months of operation, demonstrating that not only was it slow, error prone, and insecure, it was 
also down much of the time.

Why is it that companies like Amazon.com can build software that serves a much large customer base so much better? 
While the media uncovered many questionable decisions, a surprising amount of the blame was placed on the methodology 
used to develop the software (Johnson and Reed 2013). Given their approach, as one commentator said, “The real news 
would have been if it actually did work.” (Johnson 2013a)

We’re honored to have the chance to explain how Internet companies and others build successful software services and 
extend the reach of those services to the billions of mobile devices out there. As this introduction illustrates, this 
field is not some dreary academic discipline where few care what happens: failed software projects can become infamous, 
and can even derail Presidents. On the other hand, successful software projects can create services that billions of 
people use every day whose creators become household names. All involved with such services are proud to be associated 
with them, unlike the ACA.

The rest of this chapter explains why disasters like ACA can happen and how to avoid repeating this unfortunate history. 
We start our journey with the origins of software engi- neering itself, which began with software development methodologies 
that placed a heavy emphasis on planning and documenting, since that approach had worked well in other “big” engineering 
projects such as civil engineering. We next review the statistics on how well the *Plan-and-Document* methodologies worked, 
alas documenting that project outcomes like ACA are all too common, if not as well known. The frequently disappointing 
results of following conventional wisdom in software engineering inspired a few software developers to stage a revolt. 
While the *Agile Manifesto* was quite controversial when it was announced, over time Agile software development has overcome 
its critics. Agile allows small teams to outperform the industrial giants, especially for small projects. Our next step in 
the journey demonstrates how *service-oriented architecture* allows the successful composition of large software services 
like Amazon.com from many smaller software services developed and op- erated by small Agile teams.

As a final but critical point, it’s rare in practice for software developers to do “green field” development, in which 
they start from a blank slate. It’s much more common to enhance large existing code bases. The next step in our journey 
observes that unlike Plan-and-Document, which aims at a perfect design up front and then implements it, the Agile process 
spends almost all of its time enhancing working code. Thus, by getting good at Agile, you are also practicing the skills 
you need to evolve existing code bases.

To start us on our journey, we introduce the software methodology used to develop HealthCare.gov.
