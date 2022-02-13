Debugging: When Things Go Wrong
====================================

Debugging is an annoying but invaluable skill. The amazing sophistication of today’s software 
stacks makes it possible to be highly productive, but with so many “moving parts,” it also means 
that things inevitably go wrong, especially when learning new languages and tools. Errors might 
happen because you mistyped something, because of a change in your environment or configuration, 
or any number of other reasons.

The best way to debug, of course, is to stop a bug in its tracks and fix it before it manifests. 
Two fundamental suggestions can help. First, use good tools, including a text editor that supports 
automatic indentation and syntax highlighting. Syntax errors such as incomplete block structure, 
missing quotation marks, and so on become easy to catch. If your editor isn’t so equipped, you can 
either write your code on stone tablets, or switch to a more productive modern editor.

Second, use good colleagues! Many, many students taught by your authors report that they saved huge 
amounts of time by always pair programming (Section 2.2), because their partner caught a “silly” bug 
before it became a work stopper. If you’re not pairing but you’re in an “open seating” configuration, 
or have instant messaging enabled using a tool such as Slack, put the message out there. Try explaining 
your code line by line to a colleague, or if
no colleague is available, to a pet or even an inanimate object. The act of trying to explain in detail 
may lead you to discover the flaw in your own reasoning.

But neither good tools nor good colleagues are substitute for your own thinking and de- bugging skills—after all, 
it’s your code! Debugging usually involves a gradient of activities you can think of as a rising TIDE:

1. **T** race the source of the error as closely as possible by really examining the error message(s) and log file(s) closely.
2. **I** nstrument the code near the error, such as by inserting statements to print intermediate values of variables, to see where things go off the rails (so to speak).
3. **D** ebug interactively using the facilities provided in your language or framework, such as the byebug gem for Ruby, so you can inspect and modify application state around the bug.
4. **E** xplore question boards such as StackOverflow for similar bugs, and if all else fails, post a question there and ask for help.

We consider each of these in turn.

**Trace**. If the bug causes your app to crash or report an error message, take the time to really read the error message. Ruby’s 
error messages can look disconcertingly long, but a long error message is your friend because it gives the **backtrace** showing 
not only the method where the error occurred, but also its caller, its caller’s caller, and so on. Don’t throw up your hands 
when you see a long error message; use the information to understand both the proximate cause of the error (the problem that 
“stopped the show”) and the possible paths towards the root cause of the error. What is the last line of *your* code implicated 
in the backtrace? What happened before then?

This step can be challenging if the bug occurs in code that you blindly cut-and-pasted with no understanding of how it works 
or what assumptions it makes.

For example, a particularly common proximate cause of Ruby errors is :code:`Undefined` method :code:`’foobar’` for :code:`nil:NilClass`. (:code:`NilClass` is 
a special class whose only instance is the constant :code:`nil`.) This error occurs when some computation fails and returns :code:`nil` 
instead of the object you expected, but you forgot to check for this error and subsequently tried to call a method on what 
you assumed was a valid object. If the computation occurred in another method “upstream,” the backtrace can help you figure 
out where. In SaaS apps, this confusion can be compounded if the failed computation happens in the controller action
but the invalid object is referenced in the view, as in this example:

.. code-block:: ruby

    # in controller action:
    def show
        @movie = Movie.where(:id => params[:id]) # what if this movie not in DB?
        # BUG: we should check @movie for validity here!
    end

    # later, in the view - this will fail since @movie is nil
    <h1> <%=  @movie.title %> </h1>

If you’re not sure you even understand the error message, use a search engine to look up key words or key phrases in 
the error message. You can also search sites like StackOverflow, which specialize in helping out developers and 
allow you to vote for the most helpful answers to particular questions so that they eventually percolate to the top 
of the answer list.

Lastly, don’t forget that the log file :code:`development.log` (or :code:`production.log` in the production environment, or :code:`test.log` 
during a testing run) contains information such as what specific HTTP request was received, what controller action was 
invoked, whether the action succeeded or failed or redirected, what database queries if any were performed, and so on. 
With so many moving parts, there is a lot of “invisible” machinery that gets invoked before your controller code is even 
reached, and problems that happen there can be hard to find.

**Instrument. instrumentation** consists of extra statements you insert to record values of important variables at various points during 
program execution. There are various places you can instrument a Rails SaaS app:


• Display a detailed description of an object in a view. For example, try inserting :code:`<%= debug(@movie)%>` or :code:`<%= @movie.inspect%>` in any view to insert the result of the corresponding Ruby expression into the view itself.
• “Stop the show” inside a controller method by raising an exception whose message is a representation of the value you want to inspect, for example, :code:`raise params.inspect` to see the detailed value of the :code:`params` hash inside a controller method. Rails will display the exception message as the Web page resulting from the request.
• Use :code:`Rails.logger.debug(` *message* :code:`)` in a model or controller to emit *message* to the log.

**Debug interactively.** The byebug gem is already installed via the default Rails Gemfile. To use the debugger in a Rails app, 
insert the statement byebug at the point in your code where you want to stop the program. When you hit that statement, the 
terminal window where you started the server will give you a debugger prompt. In Section 4.4, we’ll show how to use the 
debugger to shed some light on Rails internals.

**Explore** question boards. Many bugs are not unique to a specific app but have happened to others in the past. Before you 
think about posting a question to a board such as StackOverflow, remember that it can take hours or days to get a 
response (if you get one), so 15 minutes spent carefully searching previous posts could save you a lot of time.

If that approach fails and you decide to post a question, remember that everyone else on StackOverflow is as busy as 
you, so write your question in a way that makes it easy for a
knowledgeable person to find and answer. Choose your keywords specifically and carefully: :code:`rails` is extremely common, 
but the conjunction :code:`rails controller redirect` narrows the topic down significantly. In the question post itself, 
be as specific as possible about what went wrong, what your environment is, and how to reproduce the problem. The 
ideal question post will express as concisely and specifically as possible (a) what your code is supposed to do, 
(b) the result you expected, (c) the result you actually observe. Here are some examples and anti-examples:

• **Vague:** “The sinatra gem doesn’t work on my system.” There’s not enough information here for anyone to help you.
• **Better, but annoying**: “The :code:`sinatra gem` doesn’t work on my system. Attached is the 85-line error message.” Other developers are just as busy as you and probably won’t take the time to extract relevant facts from a long trace.
• **Best:** Look at the actual transcript of this question on StackOverflow. At 6:02pm, the developer provided specific information, such as the name and version of their operating system, the specific commands they successfully ran, and the unexpected error that resulted. Other helpful voices chimed in asking for specific additional information, and by 7:10pm, two of the answers had identified the problem.


While it’s impressive that this developer got their answer in just over an hour, it means they also lost an hour of 
coding time, which is why you should post a question only after you’ve exhausted the other alternatives.

**Self-Check 4.8.1.** *Why can’t you just use print or puts to display messages to help debug your 
SaaS app?*

    Unlike command-line apps, SaaS apps aren’t attached to a terminal window, so there’s no obvious place for 
    the output of a print statement to go.


**Self-Check 4.8.2.** *Of the three debugging methods described in this section, which ones are appropriate for 
collecting instrumentation or diagnostic information once your app is deployed and in production?*

    Only the :code:`logger` method is appropriate, since the other two methods (“stopping the show” in a controller or inserting 
    diagnostic information into views) would interfere with the usage of real customers if used on a production app.