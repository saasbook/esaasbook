Reporting and Fixing Bugs: The Five R’s
====================================
Inevitably, bugs happen. If you’re lucky, they are found before the software is in 
production, but production bugs happen too. Everyone on the team must agree on processes 
for managing the phases of the bug’s lifecycle:


1. **R**\eporting a bug
2. **R**\eproducing the problem, or else **R**\eclassifying it as “not a bug” or “won’t be fixed” 
3. Creating a **R**\egression test that demonstrates the bug
4. **R**\epairing the bug
5. **R**\eleasing the repaired code

Any stakeholder may find and report a bug in server-side or client-side SaaS code. A member 
of the development or QA team must then reproduce the bug, documenting the environment and 
steps necessary to trigger it. This process may result in reclassifying the bug as “not a bug” 
for various reasons:


• This is not a bug but a request to make an enhancement or change a behavior that is working as designed
• This bug is in a part of the code that is being undeployed or is otherwise no longer supported
• This bug occurs only with an unsupported user environment, such as a very old browser lacking necessary features for this SaaS app
• This bug is already fixed in the latest version (uncommon in SaaS, whose users are always using the latest version)

Once the bug is confirmed as genuine and reproducible, it’s entered into a bug management system. 
A plethora of such systems exists, but the needs of many small to medium teams can be met by a 
tool you’re already using: Pivotal Tracker allows marking a story as a Bug rather than a Feature, 
which assigns the story zero points but otherwise allows it to be tracked to completion just like 
a regular user story. An advantage of this tool is that Tracker manages the bug’s lifecycle for 
you, so existing processes for delivering user stories can be readily adapted to fixing bugs. For 
example, fixing the bug must be prioritized relative to other work; in a waterfall process, this 
may mean prioritization relative to other outstanding bugs while in the maintenance phase, but 
in an Agile process it usually means prioritization relative to developing new features from 
user stories. Using Tracker, the Product Manager can move the bug story above or below other 
stories based on the bug’s severity and impact on the customer. For example, bugs that may 
cause data loss in production will get prioritized very high.

The next step is repair, which always begins with *first* creating the *simplest possible* automated 
test that fails in the presence of the bug, and *then* changing the code to make the test(s) pass 
green. This should sound familiar to you by now as a TDD practitioner, but this practice is true 
even in non-TDD environments: *no bug can be closed out without a test*. Depending on the bug, 
unit tests, functional tests, integration tests, or a combination of these may be required. 
*Simplest* means that the tests depend on as few preconditions as possible, tightly circumscribing 
the bug. For example, simplifying an RSpec unit test would mean minimizing the setup preceding 
the test action or in the before block, and simplifying a Cucumber scenario would mean minimizing 
the number of :code:`Given` or :code:`Background` steps. These tests usually get added to the regular regression 
suite to ensure the bug doesn’t recur undetected. A complex bug may require multiple commits to 
fix; a common policy in BDD+TDD projects is that commits with failing or missing tests shouldn’t 
be merged to the main development branch until the tests pass green.

Many bug tracking systems can automatically cross-reference bug reports with the commit-IDs that 
contain the associated fixes and regression tests. For example, using GitHub’s service hooks, a 
commit can be annotated with the story ID of the corresponding bug or feature in Tracker, and 
when that commit is pushed to GitHub, the story is automati- cally marked as Delivered. Depending 
on team protocol and the bug management system in use, the bug may be “closed out” either 
immediately by noting which release will contain the fix or after the release actually occurs.

As we will see in Chapter 12, in most Agile teams releases are very frequent, shortening 
the bug lifecycle.

**Self-Check 10.6.1.** *Why do you think “bug fix” stories are worth zero points in Tracker even 
though they follow the same lifecycle as regular user stories?*

    A team’s velocity would be artificially inflated by fixing bugs, since they’d get 
    points for implementing the feature in the first place and then more points for actually 
    getting the implementation right.

**Self-Check 10.6.2.** *True or false: a bug that is triggered by interacting with another 
service (for example, authentication via Twitter) cannot be captured in a regression 
test because the necessary conditions would require us to control Twitter’s behavior.*

    False: integration-level mocking and stubbing, for example using the FakeWeb gem or the 
    techniques described in Section 8.4, can almost always be used to mimic the external 
    conditions necessary to reproduce the bug in an automated test.

**Self-Check 10.6.3.** *True or false: a bug in which the browser renders the wrong content or 
layout due to JavaScript problems might be reproducible manually by a human being, but it
cannot be captured in an automated regression test.*

    False: tools such as Jasmine and Webdriver (Section 6.8) can be used to develop such tests.