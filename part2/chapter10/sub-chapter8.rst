Fallacies and Pitfalls
====================================

**Fallacy: If a software project is falling behind schedule, you can catch up by adding 
more people to the project.**

The main theme of Fred Brooks’s classic book, *The Mythical Man-Month*, is that not only does 
adding people not help, it makes it worse. The reason is twofold: it takes a while for new 
people to learn about the project, and as the size of the project grows, the amount of
communication increases, which can reduce the time available for people to get their work
done. His summary, which some call Brooks’s Law, is

    *Adding manpower to a late software project makes it later.*

    —Fred Brooks, Jr.

**Pitfall: Dividing work based on the software stack rather than on features.**

It’s less common than it used to be to divide the team into a front-end specialist, 
back-end specialist, customer liaison, and so forth, but it still happens. Your authors 
and others believe that better results come from having each team member deliver *all* 
aspects of a chosen feature or story—Cucumber scenarios, RSpec tests, views, controller 
actions, model logic, and so on. Especially when combined with pair programming, having 
each developer maintain a “full stack” view of the product spreads architectural knowledge 
around the team.

**Fallacy: It’s fine to make simple changes on the main branch.**

Programmers are optimists. When we set out to change our code, we always think it will be a 
one-line change. Then it turns into a five-line change; then we realize the change affects 
another file, which has to be changed as well; then it turns out we need to add or change 
existing tests that relied on the old code; and so on. For this reason, *always* create a 
feature branch when starting new work. Branching with Git is nearly instantaneous, and if 
the change truly does turn out to be small, you can delete the branch after merging to avoid 
having it clutter your branch namespace.

**Pitfall: Forgetting to add files to the repo.**

If you create a new file but forget to add it to the repo, *your* copy of the code will still 
work but when others pull your changes your code won’t work for them. Use :code:`git status` regularly 
to see the list of Untracked Files, and use the :code:`.gitignore` file to avoid being warned about 
files you never want to track, such as binary files or temporary files.

**Pitfall: Versioning files that shouldn’t be versioned.**

If a file isn’t required to run the code, it probably shouldn’t be in the repo: temporary 
files, binary files, log files, and so on should not be versioned. If files of test data 
are versioned, they should be part of a proper test suite. Files containing sensitive 
information such as API keys should *never* be checked into GitHub in plaintext (i.e. without 
encryption). If the files must be checked in, they should be encrypted at rest.

**Pitfall: Accidentally stomping on changes after merging or switching branches.**

If you do a pull or a merge, or if you switch to a different branch, some files may suddenly 
have different contents on disk. If any such files are already loaded into your editor, the 
versions being edited will be *out of date*, and even worse, if you now save those files, you 
will either overwrite merged changes or save a file that isn’t in the branch you think it is. 
The solution is simple: *before* you pull, merge or switch branches, make sure you commit all 
current changes; *after* you pull, merge or switch branches, reload any files in your editor 
that may be affected—or to be really safe, just quit your editor before you commit. Be careful
too about the potentially destructive behavior of certain Git commands such as :code:`git reset`,
as described in “Gitster” Scott Chacon’s informative and detailed blog post.

**Pitfall: Letting your copy of the repo get too far out of sync with the origin 
(authoritative) copy.**

It’s best not to let your copy of the repo diverge too far from the origin, or merges 
(Section 10.2) will be painful. You should update frequently from the origin repo before 
starting work, and if necessary, rebase incrementally so you don’t drift too far away 
from the main branch.

**Fallacy: Since each subteam is working on its own branch, we don’t need to communicate 
regularly or merge frequently.**

Branches are a great way for different team members to work on different features 
simultaneously, but without frequent merges and clear communication of who’s working on 
what, you risk an increased likelihood of merge conflicts and accidental loss of work when 
one developer “resolves” a merge conflict by deleting another developer’s changes.

**Pitfall: Making commits too large.**

Git makes it quick and easy to do a commit, so you should do them frequently and make 
each one small, so that if some commit introduces a problem, you don’t have to also 
undo all the other changes. For example, if you modified two files to work on feature 
A and three other files to work on feature B, do two separate commits in case one set 
of changes needs to be undone later. In fact, advanced Git users use :code:`git add` with specific 
files, rather than :code:`git add .` which adds every file in the current directory, to “cherry pick” 
a subset of changed files to include in a commit. And don’t forget that no one else will see 
the commit until you use git push to propagate them to the team’s origin repo.
