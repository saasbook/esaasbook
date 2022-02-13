The Plan-And-Document Perspective on Operations
================================================
Non-functional requirements can be more important than adding new features, as 
violations can cause loss of millions of dollars, millions of users, or both. For 
example, sales for Amazon.com in the fourth quarter of 2012 was $23.3B, so the 
loss of income due to Amazon being down just one hour would average $10M. That same 
year a break-in of the Nebraska Student Information System revealed social security 
numbers of anyone who applied to the University of Nebraska since 1985, estimated as 
650,000 people. If customers can’t trust a SaaS app, they will stop using it no matter 
what the set of features.

**Performance.** Performance is not a topic of focus in conventional software engineering, 
in part because it has been the excuse for bad practices and in part because it is well 
covered elsewhere. Performance can be part of the non-functional requirements and then 
later in acceptance-level testing to ensure the performance requirement is met.

**Release Management.** Plan-and-document processes often produce software products that have 
major releases and minor releases. Using the Rails as an example, the last number of 
version 3.2.12 is a minor release, the middle number is a major release, and the first
number is such a large change that it breaks APIs so that apps need to be ported again to 
this version. A release includes everything: code, configuration files, any data, and 
documentation. Release management includes picking dates for the release, information on how 
it will be distributed, and documenting everything so that you know what exactly is in the 
release and how to make it again so that it is easy to change when you have to make the next 
release. Release management is considered a case of configuration management in 
Plan-and-Document processes, which we review in Section 10.7.

**Reliability.** The main tool in our bag to make a system dependable is redundancy. By having 
more hardware than the absolute minimum needed to run the app and store the data, the system 
has the potential to continue even if a component fails. As all physical hardware has a 
non-zero failure rate, one redundancy guideline is to make sure there is *no single* point *of 
failure*, as it can be the Achilles’ Heel of a system. Generally, the more redundancy the 
lower the chance of failure. As highly redundant systems can be expensive, it is important 
to have an adult conversation with the customer to see how dependable the app must be.

Dependability is holistic, involving the software and the operators as well as the hardware. 
No matter how dependable the hardware is, errors in the software and mistakes by the operators 
can lead to outages that reduce the **mean time to failure (MTTF)**. As dependency is a function 
of the weakest link in the chain, it may be more effective to train operators how to run the 
app or to reduce the flaws in the software than to buy more redundant hardware to run the app. 
Since “to err is human,” systems should include safeguards to tolerate and prevent operator 
errors as well as hardware failures.

A foundational assumption of the Plan-and-Document processes is that an organization can make 
the production of software predictable and repeatable by honing its process of software 
development, which should also lead to more reliable software. Hence, organizations commonly 
record everything they can from projects to learn what they can do to improve their process. 
For example, the ISO 9001 standard is granted if companies have processes in place, a method 
to see if the process is being followed, and record the results for each project so as to make 
improvements in their process. Surprisingly, standardization approval is not about the quality 
of the resulting code, it is just about the development process.

Finally, like performance, reliability can be measured. We can improve availability either 
taking longer between failures (MTTF) or by making the app reboot faster—**mean time between 
repairs (MTTR)**—as this equation shows:

.. math::

    \text{unavailability} \approx \frac{MTTR}{MTTF}

While it is hard to measure improvements in MTTF, as it can take a long time to record 
failures, we can easily measure MTTR. We just crash a computer and see how long it takes the 
app to reboot. And what we can measure, we can improve. Hence, it may be much more 
cost-effective to try to improve MTTR than to improve MTTF since it is easier to measure 
progress. However, they are not mutually exclusive, so developers can try to increase 
dependability by following both paths.

**Security.** While reliability can depend on probability to calculate availability—it is unlikely 
that several disks will fail simultaneously if the storage system is designed without hidden 
dependencies—this is not the case for security. Here there is an human adversary who is probing 
the corner cases of your design for weaknesses and then taking advantage of them to break into 
your system. The Common Vulnerabilities and Exposures database lists common attacks to help 
developers understand the difficulty of security challenges.

Fortunately, defensive programming to make your system more robust against failures can also 
help make your system more secure. For example, in a **buffer overflow attack**, the adversary 
sends too much data to a buffer to overwrite nearby memory with their own code hidden inside 
the data. Checking the inputs to ensure that the user is not sending too much data can prevent 
such attacks. Similarly, the basis of **arithmetic overflow attack** might be to supply such an 
unexpectedly large number that when added to another number it will look small due to the 
wraparound nature of overflow with 32-bit arithmetic. Checking input values or catching 
exceptions might prevent this attack. As computers today normally have multiple processors 
(“multicore”), an increasingly common attack is a **data race attack** where the program has 
non-deterministic behavior depending on the input. These concurrent programming flaws are 
much harder to detect and correct.

Testing is much more challenging for security, but one approach is use a **tiger team** as the 
adversaries who perform **penetration tests**. The team reports back to the developers the 
uncovered vulnerabilities.

**Self-Check 12.10.1.** *Besides buffer overflows, arithmetic overflows, and data races, list 
another potential bug that can lead to security problem by violating one of the three security 
principles listed above.*

    One example is improper initialization, which could violate the principle of 
    fail-safe defaults.