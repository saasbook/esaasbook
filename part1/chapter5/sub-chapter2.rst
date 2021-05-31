Single Sign-On and Third-Party Authentication
====================================

One way to be more DRY and productive is to avoid implementing functionality that 
you can instead reuse from other services. One example of this today is **authentication**—the 
process by which an entity or **principal** proves that it is who it claims to be. In SaaS, 
end users and servers are two common types of principals that may need to authenticate 
themselves. Typically, a user proves their identity by supplying a username and password 
that (presumably) nobody else knows, and a server proves its identity with a **server certificate** 
(discussed in Chapter 12) whose **integrity** can be verified using cryptography.


In the early days of SaaS, users had to establish separate usernames and passwords for each site. 
Today, an increasingly common scenario is **single sign-on** (SSO), in which the credentials established 
for one site (the *provider*) can be used to sign in to other sites that are administratively unrelated 
to it. Clearly, SSO is central to the usefulness of service-oriented architecture: It would be difficult 
for services to work together on your behalf if each had its own separate authentication scheme. Given 
the prevalence and increasing importance of SSO, our view is that new SaaS apps should use it rather 
than “rolling their own” authentication.

However, SSO presents the dilemma that while you may be happy to use your credentials on site A to login to 
site B, you usually don’t want to reveal those credentials to site B. (Imagine that site A is your financial 
institution and site B is a foreign company from whom you want to buy something.) Figure 5.6 shows how *third-party 
authentication* solves this problem using RottenPotatoes and Twitter as an example. First, the app requesting 
authentication (RottenPotatoes) creates a request to an authentication provider on which the user already 
has an account, in this case Twitter. The request often includes information about what privileges the app wants 
on the provider, for example, to be able to tweet as this user or learn who the user’s followers are.

A typical SSO process is illustrated by the OAuth2 protocol, which begins with a link or button the user must 
click. That link takes the user to a login page served securely *by the provider*. The user is then given the 
chance to login to the provider and decide what privileges to grant the requesting app. Critically, this interaction 
takes place entirely between the user and the provider: the requesting app has no access to any part of this interaction.

.. code-block:: shell
    :emphasize-lines: 1

    rails generate model Moviegoer name:string provider:string uid:string

.. code-block:: ruby
    

    # Edit app/models/moviegoer.rb to look like this:
    class Moviegoer < ActiveRecord::Base
        def self.create_with_omniauth(auth)
            Moviegoer.create!(
            :provider => auth["provider"],
            :uid => auth["uid"],
            :name => auth["info"]["name"])
        end
    end

Once authentication succeeds, the provider generates an HTTP :code:`POST` to a particular route on the requesting app. 
This post request contains an **access token**—a string created using cryptographic techniques that can be passed back 
to the provider later, allowing the provider to verify that the token could only have been created as the result 
of a successful login process. At this point, the requesting app is able to do two things:

1. Itcanbelievethattheuserhasprovenheridentitytotheprovider,andoptionallyrecord the provider’s persistent user-ID (uid) for that user, usually provided as part of the access token. For example, Armando Fox’s uid on Twitter happens to be 318094297, though this information isn’t useful unless accompanied by an access token granting the right to obtain information about that uid.
2. It can use the token to request further information about the user from the provider, depending on what specific privileges were granted along with successful authentication. For example, a token from Facebook might indicate that the user gave permission for the app to learn who his friends are, but denied permission for the app to post on his Facebook wall.

Happily, adding third-party authentication to Rails apps is straightforward. Of course, before we can enable a user to 
log in, we need to be able to represent users! So before continuing, create a basic model and migration following the 
instructions in Figure 5.7. There are three aspects to managing third-party authentication in SaaS:

1. How to authenticate the user via a third party authentication provider (“auth provider”) such as Google or GitHub
2. How to remember that the user has logged in successfully
3. How to link the user’s ID in our own app with that provider’s ID, so that we can recognize this user in the future

By far the simplest way to accomplish the first task in Rails is Rails. The first is how to actually authenticate the 
user via a third party. We will use the excellent OmniAuth9 gem, which provides a uniform API to many different SSO 
providers, abstracting away the entire process in Figure 5.6. No matter which provider is used, OmniAuth arranges to 
send the
user to the provider’s login page, handle the providers’ callbacks for successful or failed authentication, and 
generating :code:`GET` requests to well-known routes in your app to handle these cases. To use OmniAuth, you install both 
the OmniAuth gem and the necessary additional gems for each auth provider *strategy*.

Figure 5.8 shows the changes necessary to your routes, controllers, and views to use Om- niAuth. Most auth providers 
require you to register any apps that will use their site for authentication, so in this example you would need to 
create a Twitter developer account, which will assign you an API key and an API secret that you specify in 
:code:`config/initializers/omniauth.rb` (Figure 5.8, bottom). The second aspect of handling authentication is keeping track 
of whether the current user has been authenticated. You may have already guessed that this information can be stored 
in the :code:`session[]`. However, we should keep session management separate from the other concerns of the app, since the 
session may not be relevant if our app is used in a service-oriented architecture setting. To that end, Figure 5.8(b) 
shows how we can “create” a session when a user successfully authenticates (lines 3–9) and “destroy” it when they log 
out (lines 11–15). The “scare quotes” are there because the only thing actually being created or destroyed is the value 
of :code:`session[:user_id]`, which is set to the primary key of the logged-in user during the session and nil at other times. 
Figure 5.8(c) shows how this check is abstracted by a :code:`before_filter` in :code:`ApplicationController` (which will be inherited 
by all controllers) that sets :code:`@current_user` accordingly, so that controller methods or views can just look at :code:`@current_user` 
without being coupled to the details of how the user was authenticated.

The third aspect is linking our own representation of a user’s identity—that is, her primary key in the :code:`moviegoers `
table—with the auth provider’s representation, such as the :code:`uid` in the case of Twitter. Since we may want to expand 
which auth providers our customers can use in the future, the migration in Figure 5.7(a) that creates the :code:`Moviegoer`
model specifies both a uid field and a provider field. What happens the very first time Alice logs into RottenPotatoes 
with her Twitter ID? The query in line 6 of the sessions controller (Figure 5.8(b)) will return :code:`nil`, so 
:code:`Moviegoer.create_with_omniauth` (Figure 5.7(b), lines 5–10) will be called to create a new record for this user. 
Note that “Alice as authenticated by Twitter” would therefore be a different user from our point of view than 
“Alice as authenticated by Facebook,” because we have no way of knowing that those represent the same person. 
That’s why some sites that support multiple third-party auth providers give users a way to “link” two accounts 
to indicate that they identify the same person.

This may seem like a lot of moving parts, but compared to accomplishing the same task without an abstraction such as 
OmniAuth, this is very clean code: we added fewer than two dozen lines, and by incorporating more OmniAuth strategies, 
we could support additional third-party auth providers with essentially no new work. Screencast 5.2.1 shows the user 
experience associated with this code.

However, we must be careful to avoid creating a security vulnerability. What if a malicious attacker crafts a form 
submission that tries to modify :code:`params[:moviegoer][:uid]` or :code:`params[:moviegoer][:provider]`—fields that should only be 
modified by the authentication logic—by posting **hidden form fields** named :code:`params[moviegoer][uid]` and
so on? Section 4.4 explained how the “strong parameters” feature of Rails can be used to block assignment of model 
attributes that regular users shouldn’t be able to set. While it’s fine for the :code:`create_with_omniauth` method to create 
a user with the appropriate :code:`uid`, a regular moviegoer should not be able to set their own uid since it would allow them 
to impersonate being logged in! To ensure this can’t happen, we must make sure :code:`uid` does not appear in any :code:`params.permit`
or :code:`params.require` in the Moviegoers controller.

**Self-Check 5.2.1.** *Briefly describe how RottenPotatoes could let you log in with your Twitter ID without you having 
to reveal your Twitter password to RottenPotatoes.*

    RottenPotatoes redirects you to a page hosted by Twitter where you log in as usual. The redirect includes a URL to which 
    Twitter posts back a message confirming that you’ve au- thenticated yourself and specifying what actions RottenPotatoes 
    may take on your behalf as a Twitter user.

**Self-Check 5.2.2.** *True or false: If you log in to RottenPotatoes using your Twitter ID, RottenPotatoes becomes capable 
of tweeting using your Twitter ID.*

    False: authentication is separate from permissions. Most third-party authentication providers, including Twitter, 
    allow the requesting app to ask for permission to do specific things, and leave it up to the user to decide 
    whether to allow it.