It Takes a Team: Two-Pizza and Scrum 
====================================
    *The Six Phases of a Project: (1) Enthusiasm, (2) Disillusionment, (3) Panic, 
    (4) Search for the guilty, (5) Punishment of the innocent, (6) Praise for non-participants.*
    
    —Dutch Holland (Holland 2004)

The days of the hero programmer are now past. Whereas once a brilliant 
individual could create breakthrough software, the rising bar on functionality 
and quality means software de- velopment now is primarily a team sport. Hence, 
success today means that not only do you have great design and coding skills, but 
that you work well with others and can help your team succeed. As the opening quote 
from Fred Brooks states, you cannot win if your team loses, and you cannot fail 
if your team wins.

Hence, the first step of a software development project is to form and organize a team. 
As to its size, a “two-pizza” team—a group that can be fed by two pizzas in a meeting—is 
typical for SaaS projects. Our discussions with senior software engineers suggest the 
typical team size range varies by company, with four to nine developers being a typical range.

While there are many ways to organize a two-pizza software development, a popular one today 
is **Scrum** (Schwaber and Beedle 2001). Its frequent short meetings—15 minutes every day at 
the same place and time—inspire the name, when each team member answers three questions:

1. What have you done since yesterday?
2. What are you planning to do today?
3. Are there any impediments or stumbling blocks?

The benefit of these daily scrums is that by understanding what each team member is doing 
and has already completed, the team can identify work that would help others make faster 
progress. Indeed, daily scrums are sometimes referred to as *standups*, implying that the meeting 
should be kept short enough that everyone can remain standing the entire time.

When combined with the weekly or biweekly iteration model of Agile to collect the feedback 
from all the stakeholders, the Scrum organization makes it more likely that the rapid progress 
will be towards what the customers want. Rather than use the Agile term iteration, Scrum uses 
the term **sprint**.

A Scrum has three main roles:

1. **Team**—A two-pizza size team that delivers the software.
2. **Scrum Lead**—A team member who acts as buffer between the Team and external distractions, keeps the team focused on the task at hand, enforces team rules, and removes impediments that prevent the team from making progress. One example is enforcing **coding standards**, which are style guidelines that improve the consistency and read- ability of the code.
3. **Product Owner**—A team member (not the Scrum Lead) who represents the voice of the customer and prioritizes user stories.

Scrum relies on self-organization, and team members often rotate through different roles. 
For example, we recommend that each member rotate through the Product Owner role, changing 
on every iteration or sprint.

In any group working together, conflicts can occur around which technical direction the group 
should go. Depending in part on the personalities of the members of the team, they may not be 
able to quickly reach agreement. One approach to resolving conflicts is to start with a list 
on all the items on which the sides agree, as opposed to starting with the list of disagreements. 
This technique can make the sides see that perhaps they are closer together than they thought. 
Another approach is for each side to articulate the other’s arguments. This technique makes 
sure both sides understand what the arguments are, even if they don’t agree with some of them. 
This step can reduce confusion about terms or assumptions, which may be the real cause of the 
conflict.

Of course, such an approach requires great team dynamics. Everyone on the team should ideally 
feel **psychological safety**—the belief that they will not be humiliated for voicing their ideas 
to the team, even if those ideas might turn out to be wrong. Indeed, a two-year study by Google 
found that the most effective Google teams weren’t the ones with the most senior engineers or 
the smartest people, but the teams with high psychological safety. One way Agile teams promote 
psychological safety is to do a short Retrospective meeting, often shortened to “retro,” at the 
end of each iteration. A typical format for the retro focuses on Plus/Minus/Interesting (PMI): 
each team member writes down, perhaps anonymously at first, what they thought went well, went 
poorly, and was unusual or noteworthy (neither good nor bad) during the iteration. The PMI items 
are often not technical, for example, “When I brought up my concern about some new code to 
Armando, I felt he was dismissive about my idea” or “Dave really helped me with a bug I’d been 
chasing this week without making me feel stupid.” All team members then review the items (and 
where appropriate reveal their identities, or say “I agree,” or “I noticed that too”), noting 
especially if some items were raised by more than one team member. The PMI items can also be 
compared to the previous iteration’s retro items, since one goal of Agile is continuous 
improvement.

The rest of this chapter focuses on coordinating the work of the team, and in particular the 
use of version control tools to support coordination. How is the code repository managed? What 
happens if team members accidentally make conflicting changes to a set of files? Which lines 
in a given file were changed when, and by whom were they changed? How does one developer work 
on a new feature without introducing problems into stable code? How does the team ensure the 
quality of the code and tests on an ongoing basis as more contibrutions accrete in the 
repository? As we will see, when software is developed by a team rather than an individual, 
version control can be used to address these questions using **merging** and **branching**. Both tasks 
involve combining changes made by many developers into a single code base, a task that sometimes 
requires manual resolution of conflicting changes.


**Self-Check 10.1.1.** *True or False: Scrum is an appropriate methodology when it is 
difficult to plan ahead.*

    True: Scrum relies more on real-time feedback than on the traditional management approach 
    of central planning with command and control.