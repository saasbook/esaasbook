Looking Forwards 
====================================
    *I’ve always been more interested in the future than in the past.*

    —Grace Murray Hopper

Given this history of rapidly-evolving tools, patterns, and development methodologies, 
what might software engineers look forward to in the next few years?

One software engineering technique that we expect to become popular in the next few years 
is *delta debugging* (Zeller 2002). It uses divide-and-conquer to automatically find the 
smallest input change to that will cause a bug to appear. Debuggers usually use program 
analysis to detect flaws in the code itself. In contrast, delta debugging identifies 
changes to the program *state* that lead to the bug. It requires two runs, one with the 
flaw and one without, and it looks at the differences between the sets of states. By 
repeatedly changing the inputs and re-running the program using a binary search strategy 
and automated testing, delta debugging methodically narrows the differences between the 
two runs. Delta debugging discovers dependencies that form a cause-effect chain, which 
it expands until it identifies the smallest set of changes to input variables that causes 
the bug to appear. Although it requires many runs of the program, this analysis is done at 
full program speed and without the intervention of the programmer, so it saves development time.

**Program synthesis** may be ready for a breakthrough. The state of the art today is that given 
incomplete segments of programs, program synthesis tools can often supply the missing code. 
One of the most interesting uses of this technology is in Microsoft Office Excel 2013, called 
the *Flash Fill feature*, which does programming by example (Gulwani et al. 2012). You give 
examples of what you want to do to rows or columns of code, and Excel will attempt to repeat 
and generalize what you do. Moreover, you can correct its attempts to steer it to what you 
want (Gantenbein 2012).

This split between Plan-and-Document and Agile development may become more pronounced with 
the advances in practicality of formal methods. The size of programs that can be formally 
verified is growing over time, with improvements in tools, faster computers, and wider 
understanding of how to write formal specifications. If the work of careful specification 
in advance of coding could be rewarded by not needing to test and yet have thoroughly verified 
programs, then the tradeoffs would be crisp around change. For formal methods to work, clearly 
change needs to be rare. When change is commonplace, Agile is the answer, for change is the 
essence of Agile.

While Agile works better than other software methodologies for some types of apps today, it 
is surely not the final answer in software development. If a new methodology could simplify 
including a good software architecture and good design patterns while maintaining Agile’s ease 
of change, it could become more popular. Historically, a new methodology comes along every 
decade or two, so it may soon be time for new one.

This book itself was developed during the dawn of the **Massive Open Online Course** (MOOC) movement, 
which is another trend that we predict will become more significant in the next few years. Like 
many other advances in this modern world, we wouldn’t have MOOCs without SaaS and cloud computing. 
The enabling components were:

• Scalable video distribution via services like YouTube.
• Sophisticated autograders running on cloud computing that evaluate assignments im- mediately yet can scale to tens of thousands of students.
• Discussion forums as a scalable solution to asking questions and getting answers from both other students and the staff.

These components combine to form a wonderful, low-cost vehicle for students around the world. 
For example, it will surely improve continuing education of professionals in our fast changing 
field, enable gifted pre-college students to go beyond what their schools can teach, and let 
dedicated students around the world who do not have access to great universities still get a 
good education. MOOCs may even have the side effect of raising the quality bar for traditional 
courses by providing viable alternatives to ineffective lecturers. If MOOCs deliver on only 
half of these opportunities, they will still be a potent force in higher education.
