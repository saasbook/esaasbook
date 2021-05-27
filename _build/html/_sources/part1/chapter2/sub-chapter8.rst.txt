Concluding Remarks: How (Not) To Learn a Language By Googling 
====================================

Your authors will allow themselves a literary flourish and frame the advice in this section with two quotes. 
The first is from Tom Knight, one of the principal designers of Lisp machines—research computers designed at MIT 
to optimize running programs in the Lisp programming language.

    A novice was trying to fix a broken Lisp machine by turning the power off and on. Knight, seeing what the student was doing, 
    spoke sternly: “You cannot fix a machine by just power-cycling it with no understanding of what is going wrong.” Knight 
    turned the machine off and on. The machine worked.

    —“AI Koans” section of The New Hacker’s Dictionary

To us, the above quote captures the perils of blindly copy-pasting code without understanding how it works: the code may appear 
to work initially, but if you don’t know why, or if it breaks something else, you may get into trouble in the future, and you 
certainly won’t learn much. While programmer Q&A sites such as StackOverflow are invaluable for both asking questions and discovering 
code snippets to perform specific tasks, your strategy should be to find a general *pattern* matching what you’re trying to do, then 
once you fully understand how the found works, *adapt* it for your specific situation. In other words, search for *what, not how*.

The second quote is from the author of *The Cathedral and the Bazaar* (Raymond 2001), an early exposition of the potential advantages of open-source development:

    Ugly programs are like ugly suspension bridges: they’re much more liable to collapse than pretty ones, because the way humans (especially engineer-humans) 
    perceive beauty is intimately related to our ability to process and understand complexity. A language that makes it hard to write elegant code makes it 
    hard to write good code.

    —Eric S. Raymond

Learning to use a new language and making the most of its idioms is a vital skill for software professionals. These are not easy tasks, but we hope that 
focusing on unique and beautiful features in our exposition of Ruby and JavaScript will evoke intellectual curiosity rather than groans of resignation, 
and that you will come to appreciate the value of wielding a variety of specialized tools and choosing the most productive one for each new job.

If this is your first exposure to Ruby, then functional programming and blocks in Ruby and closures in JavaScript may take some getting used to. But as 
with any language, not learning to use the idioms properly may result in missing the opportunity to use a mechanism in the new language that might 
provide a more beautiful solution.

Our advice is therefore to persevere in a new language until you’re comfortable with its idioms. Resist the temptation to “transliterate” your code from 
other languages without first considering whether there’s a more idiomatic way to express what you need in the target language.

If you want to expand your “programming language cross training” program, we recommend *Seven Languages In Seven Weeks* (Tate 2010), which introduces the 
reader to a set of languages that invite radically different ways of thinking about expressing programming tasks.

Finally, we recommend these resources for more detail on Ruby itself. Again, we assume that Ruby is not your first language and that this book and course 
are not your first exposure to programming, so we omit references aimed at beginners.

• Programming Ruby and *The Ruby Programming Language* (Flanagan and Mat- sumoto 2008), co-authored by Ruby inventor Yukihiro “Matz” Matsumoto, are definitive references for Ruby.
• The online documentation for Ruby gives details on the language, its classes, and its standard libraries. A few of the most useful classes include :code:`IO` (file and network I/O, including CSV files), :code:`Set` (collection operations such as set difference, set intersection, and so on), and :code:`Time` (the standard class for representing times, which we recommend over :code:`Date` even if you’re representing only dates without times). These are reference materials, not a tutorial.
• *Learning Ruby* (Fitzgerald 2007) takes a more tutorial-style approach to learning the language.
• *The Ruby Way* is an encyclopedic reference to both Ruby itself and how to use it id- iomatically to solve many practical programming problems.
• *Ruby Best Practices* (Brown 2009) focuses on how to make the best of Ruby’s “power tools” like blocks, modules/duck-typing, metaprogramming, and so on. If you want to write Ruby like a Rubyist, this is a great read.
• Many newcomers to Ruby have trouble with yield, which has no equivalent in Java, C or C++ (although recent versions of Python and JavaScript do have similar mech- anisms). The **coroutines** article on Wikipedia gives good examples of the general coroutine mechanism that yield supports.
