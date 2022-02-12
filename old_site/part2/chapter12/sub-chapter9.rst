Security: Defending Customer Data in Your App
==============================================
As security is its own field in computing, there is no shortage of material to 
review or topics to study. Perhaps as a result, security experts have boiled down 
their advice into principles that developers can follow. Here are three:

• The **principle of least privilege** states that a user or software component should be given no more privilege—that is, no further access information and resources—than what is necessary to perform its assigned task. This is analogous to the “need-to-know” principle for classified information. One example of this principle in the Rails world is that the Unix processes corresponding to your Rails app, your database, and the Web server (presentation tier) should run with low privilege and in an environment where they cannot even create new files in the file system. Good PaaS providers, including Heroku, offer a deployment environment configured in just this way.
• The *principle of fail-safe defaults* states that unless a user or software component is given explicit access to an object, it should be denied access to the object. That is, the default should be denial of access. Proper use of strong parameters as described in Section 5.2 follows this principle.
• The *principle of psychological acceptability* states that the protection mechanism should not make the app harder to use than if there were no protection. That is, the user interface needs to be easy to use so that the security mechanisms are routinely followed.

The rest of this section covers six specific security vulnerabilities that are particularly 
relevant for SaaS applications: protecting data using encryption, cross-site request forgery, 
SQL injection and cross-site scripting, clickjacking, prohibiting calls to private controller 
methods, and self-denial-of-service.

**Protecting Data Using Encryption.** Since competent PaaS providers make it their business to stay 
abreast of security-related issues in the infrastructure itself, developers who use PaaS can 
focus primarily on attacks that can be thwarted by good coding practices. Data-related attacks 
on SaaS attempt to compromise one or more of the three basic elements of security: privacy, 
authenticity, and data integrity. The goal of **Transport Layer Security** (TLS) and its 
predecessor Secure Sockets Layer (SSL) is to **encrypt** all HTTP traffic by transforming it using 
cryptographic techniques driven by a secret (such as a password) known only to the two 
communicating parties. Running HTTP over such a secure connection is called HTTPS.

Establishing a shared secret with a site you’ve never visited before is a challenging 
problem whose practical solution, **public key cryptography**, is credited to Ron Rivest, Adi 
Shamir and Len Adleman (hence **RSA**). A **principal** or communicating entity generates a keypair 
consisting of two matched parts, one of which is made public (accessible to everyone in the 
world) and the other of which is kept secret.

A keypair has two important properties:

1. A message encrypted using the private key can only be decrypted using the public key, and vice-versa.
2. The private key cannot be deduced from the public key, and vice-versa.

Property 1 provides the foundation of public-key encryption: if you receive a message that is 
decryptable with Bob’s public key, only someone possessing Bob’s private key could have created 
it. A variation is the digital signature: to attest to a message, Bob generates a one-way digest 
of the message (a short “fingerprint” that would change if the message were altered) and encrypts 
the digest using his private key as a way of attesting “I, Bob, vouch for the information in 
the message represented by this digest.”

To offer secure access to his site :code:`rottenpotatoes.com`, Bob generates a keypair consisting of a 
public part KU and a private part KP. He proves his identity using conventional means such as 
government-issued IDs to a **certificate authority** (CA) such as VeriSign. The CA then uses its 
own private key CP to sign an **public key certificate** that states, in effect, 
“:code:`rottenpotatoes.com` has public key *KU*.” Bob installs the certificate on his server and
enables his SaaS stack to accept secure connections—usually trivial in a PaaS environment. 
Finally, he enables secure connections in his Rails app by adding :code:`config.force_ssl=true` to his 
:code:`config/environments/production.rb`, which turns on secure connections in production but not 
for development or testing.

The CA’s public key CU is built into most Web browsers, so when Alice’s browser first connects 
to :code:`https://rottenpotatoes.com` and requests the certificate, it can verify the CA’s signature 
and obtain Bob’s public key *KU* from the certificate. Alice’s browser then chooses a random 
string as the secret, encrypts it using *KU*, and sends it to rottenpotatoes.com, which alone 
can decrypt it using *KP*. This shared secret is then used to encrypt HTTP traffic using much 
faster **symmetric-key cryptography** for the duration of the session. At this point, any content 
sent via HTTPS is reasonably secure from eaves- droppers, and Alice’s browser believes the 
server it’s talking to is the genuine RottenPotatoes server, since only a server possessing 
*KP* could have completed the key exchange step.

It’s important to recognize that this is the limit of what a secure HTTP connection can do. 
In particular, the server knows nothing about Alice’s identity, and no guarantees can be made 
about Alice’s data other than its privacy during transmission to RottenPotatoes.

**Cross-site request forgery.** A CSRF attack (sometimes pronounced “sea-surf”) involves
tricking the user’s browser into visiting a different web site for which the user has a valid
cookie, and performing an illicit action on that site as the user. For example, suppose Alice
has recently logged into her MyBank.com account, so her browser now has a valid cookie for
MyBank.com showing that she is logged in. Now Alice visits a chat forum where malicious
Mallory has posted a message with the following embedded “image”:

.. code-block:: html
    :linenos:

    <p>Here's a risque picture of me:
        <img src="http://mybank.com/transfer/mallory/5000"> 
    </p>

When Alice views the blog post, or if she receives an email with this link embedded in it, 
her browser will try to “fetch” the image from this RESTful URI, which happens to transfer 
$5000 into Mallory’s account. Alice will see a “broken image” icon without realizing the 
damage. CSRF is often combined with Cross-site Scripting (see below) to perform more 
sophisticated attacks.

There are two steps to thwarting such attacks. The first is to ensure that RESTful actions 
performed using the :code:`GET` HTTP method have no side effects. An action such as bank withdrawal 
or completing a purchase should be handled by a POST. This makes it harder for the attacker 
to deliver the “payload” using embedded asset tags like :code:`IMG`, which browsers *always* handle 
using :code:`GET`. The second step is to insert a randomly-generated string based on the current 
session into every page view and arrange to include its value as a hidden form field on every 
form. This string will look different for Alice than it will for Bob, since their sessions 
are distinct. When a form is submitted without the correct random string, the submission is 
rejected. Rails automates this defense: all you need to do is render :code:`csrf_meta_tags` in every 
such view and add :code:`protect_from_forgery` to any controller that might handle a form submission. 
Indeed, when you use :code:`rails new` to generate a new app, these defenses are included in 
:code:`app/views/layouts/application.html.erb` and :code:`app/controllers/ application_controller.rb` respectively.

.. code-block:: ruby
    :linenos:

    class MoviesController 
        def search
            movies = Movie.where("name = '#{params[:title]}'") # UNSAFE!
            # movies = Movie.where("name = ?", params[:title]) # safe
        end 
    end

**SQL injection and cross-site scripting.** Both of these attacks exploit SaaS apps that handle 
attacker-provided content unsafely. Defending against both can be summarized by the same 
advice: *sanitize any content coming from the user.* In **SQL injection**, Mallory enters form 
data that she hopes will be interpolated directly into a SQL query statement executed
by the app. Figure 12.12 shows an example and its defense: using prepared statements, in which 
“dangerous” characters in parts of the SQL statement are properly escaped. In **cross-site 
scripting** (XSS), Mallory prepares a fragment of JavaScript code that performs a harmful 
action. Her goal is to get RottenPotatoes to render that fragment as part of a displayed HTML 
page, triggering execution of the script. Figure 12.13 shows how Mallory might try to do this, 
by creating a movie whose :code:`title` attribute is a simple piece of JavaScript that will display an 
alert; real examples often include JavaScript code that steals Alice’s valid cookie and transmits 
it to Mallory, who can now “hijack” Alice’s session by passing Alice’s cookie as her own. Worse, 
even if the XSS attack only succeeds in reading the page content from another site and not the 
cookie, the page content might contain the CSRF-prevention token generated by :code:`csrf_meta_tags` 
corresponding to Alice’s session, so XSS is often used to enable CSRF. Fortunately, the Rails 
Erb renderer always escapes “dangerous” HTML characters by default, as the figure shows; to 
prevent Erb from escaping a string :code:`s`, you must render :code:`raw(s)`, and if you do so, you’d better 
have a good reason for believing it is safe, such as having separately sanitized :code:`s` when it was 
first received from Mallory.

.. code-block:: erb
    :linenos:

    <h2><%= movie.title %></h2>
    <p>Released on <%= movie.release_date %>. Rated <%= movie.rating %>.</p>

.. code-block:: html
    :linenos:

    <h2><script>alert("Danger!");</script></h2>
    <p>Released on 1992-11-25 00:00:00 UTC. Rated G.</p>

.. code-block:: html
    :linenos:

    <h2>&lt;script&gt;alert("Danger!");&lt;/script&gt;</h2> 
    <p> Released on 1992-11-25 00:00:00 UTC. Rated G.</p>

**Clickjacking** or *UI redress attacks* are aimed at getting the user to take a UI action they 
normally wouldn’t take, by obfuscating that action in the UI. Like XSS, they rely on 
deceiving the user regarding which site is actually displaying what they’re seeing. For 
example, suppose you want to get many people to buy your widget on Amazon. First, create an 
unrelated page that has a “bait button” on it, such as “Click here for a free gift card.” 
Craft that page so that it loads the Amazon product page for your widget into an HTTP :code:`iframe`, 
and uses CSS to make the framed Amazon page transparent (invisible) but layered logically on 
top of the bait page, so that the “invisible” page is actually the one whose UI elements 
receive click events. Then position the framed page (more CSS) such that the Amazon “Buy Now 
With 1-Click” button is positioned directly over the bait button. The user thinks they’re 
clicking the bait button, but in fact it’s the Amazon button that receives the event and is 
activated. Of course, the user must be signed into Amazon for this to work, but there are many 
sites on which users have selected “remember me” so they don’t have to login every time. 
Clickjacking was famously used in 2010 to garner many illegitimate Likes for a particular 
Facebook page.

The most effective defense against clickjacking is to ensure your site’s pages cannot be 
framed on another site. All modern browsers observe the :code:`X-Frame-Options` HTTP header; if 
the value is :code:`SAMEORIGIN`, framing of a page is only allowed by other pages from the same site. 
Rails 4 and later set this header by default, but in earlier versions, the :code:`secure_headers` gem 
was necessary to set it explicitly.

**Prohibiting calls to private controller methods.** It’s not unusual for controllers to include 
“sensitive” helper methods that aren’t intended to be called by end-user actions, but only 
from inside an action. Use :code:`protected` for any controller method that isn’t the target of a 
user-initiated action and check :code:`rake routes` to make sure no routes include wildcards that 
could match a nonpublic controller action.

**Self-denial-of-service.** A malicious denial-of-service attack seeks to keep a server busy doing 
useless work, preventing access by legitimate users. You can inadvertently leave yourself open 
to these attacks if you allow arbitrary users to perform actions that result in a lot of work 
for the server, such as allowing the upload of a large file or generating an expensive report. 
For this reason, “expensive” actions are usually handled by a separate background process. For 
example, with Heroku, your app can queue the action using a simple queue system such as Redis, 
and a Heroku background worker can be triggered to pull jobs off the queue and run them while 
the main app server remains available to respond to interactive requests. Uploading files also 
carries other risks, so you should “outsource” that responsibility to other services; for 
example, many PaaS providers provide plugins for SaaS apps in popular languages the facilitate 
the safe upload of files to external cloud-based storage such as Amazon Simple Storage Service 
(S3).

A final warning about security is in order. The “arms race” between SaaS developers and 
evildoers is ongoing, so even a carefully maintained site isn’t 100% safe. In addition to 
defending against attacks on customer data, you should *also* be careful about handling sensitive 
data. Don’t store passwords in cleartext; store them encrypted, or better yet, rely on 
third-party authentication as described in Section 5.2, to avoid embarrassing incidents of 
password theft. Don’t even *think* of storing credit card numbers, even encrypted. The Payment 
Card Industry association imposes an audit burden costing tens of thousands of dollars per 
year to any site that does this (to prevent credit card fraud), and the burden is only 
slightly less severe if your code ever manipulates a credit card number even if you don’t 
store it. Instead, offload this responsibility to sites like PayPal or Stripe that specialize 
in meeting these heavy burdens.

**Self-Check 12.9.1.** *True or false: If a site has a valid public key certificate, Cross-Site 
Request Forgery (CSRF) and SQL Injection attacks are harder to mount against it.*

    False. The security of the HTTP channel is irrelevant to both attacks. CSRF relies only on a 
    site erroneously accepting a request that has a valid cookie but originated elsewhere. SQL 
    injection relies only on the SaaS server code unsafely interpolating user-entered strings 
    into a SQL query.

**Self-Check 12.9.2.** *Why can’t CSRF attacks be thwarted by checking the Referer: header of an 
HTTP request?*

    The header can be trivially forged.