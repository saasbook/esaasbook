Pull Requests and Code Reviews
====================================
    *There is a really interesting group of people in the United States and around the 
    world who do social coding now. The most interesting stuff is not what they do on 
    Twitter, it’s what they do on GitHub.*

    —Al Gore, former US Vice President, 2013

Section 10.7 describes the use of design reviews or code reviews to improve quality 
of the software product. You may be surprised to learn that most companies using Agile 
methods do not perform formal design or code reviews. But perhaps more surprising is 
that experienced Agile companies’ code is *better and more frequently* reviewed compared 
to companies that do formal code reviews.

For the explanation of this paradox, recall the basic idea of extreme programming: every 
good programming practice is taken to an extreme. Section 2.2 already described one form 
of “extreme code review” in the form of pair programming, in which the navigator continuously 
reviews the code being entered by the driver. In this section we describe another form of 
code review, in which the rest of the team has frequent opportunities to review the work 
of their colleagues. Our description follows the process used at GitHub, where formal code 
reviews are rare.

When a developer (or a pair) has finished work on a branch, rather than directly merging the 
branch into the main, the developer makes a **pull request**, or PR for short, asking that the 
branch’schangesbemergedinto(usually)themainbranch. Alldeveloperssharingtherepo see each PR, 
and each has the responsibility to determine how merging those changes might affect their 
own code. If anyone has a concern, an online discussion coalesces around the PR. For example, 
GitHub’s user interface allows any developer to make comments either on the PR overall or on 
specific lines of particular files. This discussion might result in changes to the code in 
question before the PR is accepted and merged; any further changes made on the PR’s topic 
branch and pushed to GitHub will automatically be reflected in the PR, so the PR process is 
really a form of code review. And since many PRs typically occur each day, these “mini-reviews” 
are occurring continuously, so there is no need for special meetings.

The PR therefore serves as a way to focus a code review discussion on a particular set of 
changes. That said, a PR shouldn’t be opened until the developer is confident their code 
is ready. A few examples of such preparation include:

• The code to be merged should be well covered by tests, all of which should be passing.
• Documentation (design documents, the :code:`README` file, the project wiki, and so on) has been updated if necessary to explain new design decisions or changes to important configuration files (such as the :code:`Gemfile` for Ruby projects).
• Any temporary or non-essential files that were versioned during development of the code have been removed from version control.
• Steps have been taken to eliminate or minimize merge conflicts that will occur when the PR is accepted and merged.

The last item above can be tricky, because as the previous section explained, it’s not uncommon 
for a merge to encounter conflicts that must be manually resolved. Indeed, when you open a PR, 
GitHub checks and informs you whether the merge would require manual conflict resolution. Such 
a scenario motivates the possible use of *rebasing*, an operation in which you tell Git to make 
the world look as if you had branched from a later commit. For example, if there have been 3 
new commits on main since the time you branched off of it, and you now rebase your branch on 
top of main, Git will *first* apply those 3 new commits to the original state of your branch, 
and *then* try to apply your own commits. This latter step may cause conflicts if the 3 commits 
on the main branch touched some of the same files your changes have touched. If so, Git generally 
requires you to resolve each conflict as it is detected, before proceeding with the rebase, and 
allows you to abort the rebase entirely if things get too ugly. But once you have resolved those 
conflicts, merging your branch back to main is guaranteed not to cause any new conflicts (unless, 
of course, additional commits to main happened while you were rebasing). In other words, from 
the point of view of trying to merge changes into a shared main branch, rebasing before merging 
forces you to resolve the conflicts at rebasing time, thus saving work for whoever will merge 
your branch back into the main branch.

There is an important caveat to rebasing. By its very nature, rebasing rewrites history, by 
making the world look as if your branch had been created from a different commit than it 
actually was, and by rewriting the commit history of the branch itself. This rewriting of 
history can occur in one of three scenarios:

1. You have not yet pushed to the shared repo. The history of your branch exists only in your copy of the repo, so rewriting that history does not affect the team.
2. You have pushed to the shared repo, but no one else has made additional changes based on your branch. This is the common case when using branch-per-feature, since there is normally no reason for one developer to base work on another developer’s commits in a feature branch. You may need to use the :code:`--force` flag to :code:`git push` when pushing the branch, to indicate your acknowledgment that you’re changing the shared repo’s view of history.
3. You have pushed to the shared repo, and others have based work off of your changes. Anyone who has based their work off of your branch commits will now be out of sync since their history doesn’t match the shared repo’s history.

Case 3 is rare, but if it occurs, you should coordinate carefully with your team *before* forcing 
a push to avoid others’ repos getting out of sync with the shared copy. One good practice is to 
construct feature branch names in some way that signals that others should not build off of 
those commits, for example by prepending the developer’s initials to the branch name or using 
a standard naming convention such as :code:`feature-xxx` for feature branch names.

An alternative to rebasing is merging: running :code:`git pull origin main` in your feature branch 
at any time will update your clone from the origin repo, then merge any new changes
from the main branch into your feature branch. Compared with rebasing, this approach is 
nondestructive because it doesn’t rewrite history, but it also adds a lot of extra commits 
(the merge commits) to your feature branch, which can make it tricky to reconstruct the history 
of the feature branch using :code:`git log`. Atlassian has an excellent set of tutorials6 covering this 
and many other Git-related topics.

All this having been said, if you’re breaking down your user stories into tasks of manageable 
size (Section 7.4) and doing frequent deployments (Section 12.4), messy merges and rebases 
should rarely be necessary in Agile development.

**Self-Check 10.3.1.** *True or false: If you attempt* :code:`git push` *and it fails with a message such as 
“Non-fast-forward (error): failed to push some refs,” this means some file contains a merge 
conflict between your repo’s version and the origin repo’s version.*

    Not necessarily. It just means that your copy of the repo is missing some commits that are 
    present in the origin copy, and until you merge in those missing commits, you won’t be allowed 
    to push your own commits. Merging in these missing commits *may* lead to a merge conflict, but 
    frequently does not.