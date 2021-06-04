The DOM and Accessibility
====================================
Many people navigate a website by clicking on buttons or links. This relies on using a mouse or touchscreen as 
well as being able to perceive the visual affordances of the web page. Considering *accessibility*, sometimes 
abbreviated *a11y*, is about ensuring that your users can access your applications using different input methods. 
For example, some users may need (or prefer) to navigate a website using the keyboard, so they must have a way 
of “clicking” on a button, perhaps by pressing space on their keyboards. Blind or low-vision users may use *screen 
reader* software that translates text and interactions on screen into audio, and to include these users you must 
ensure there’s a way for the computer to generate a text-based description of your page elements. The :code:`alt` attribute 
of an img element, which has been part of HTML since the beginning, is one simple example of providing a textual 
alternative to visual element.

Section 1.8 motivated the use of HTML/CSS frameworks. One advantage of a good framework is that it provides some 
built-in support for using the techniques we describe in this section to improve your app’s accessibility: using 
Semantic HTML to structure your pages, and adding ARIA (Accessible Rich Internet Applications) attributes to give 
hints to screen readers.

**Semantic HTML.** HTML is very flexible: in principle you can accomplish just about any visual styling using only :code:`div` 
(“divider”) elements with appropriate CSS rules. However, a :code:`div` doesn’t convey much about the purpose of that element. 
*Semantic* *HTML* involves choosing the *most appropriate* HTML element type tag that describes the element’s logical role 
on the page, so that (for example) a screen reader can convey that a particular element
is a button, heading, paragraph, or maybe even a timestamp. Beyond accessibility, using the proper HTML element type 
communicates your intentions to other developers on the project, and allows search engines to improve their search results. 
We distinguish three categories of HTML elements: structural, content, and interactive.

**Structural elements** break down large and often visually-distinct sections of a web page, allowing screen readers to 
quickly jump between sections:

• :code:`h1...h6` are elements that give your page an outline. Most pages start with :code:`h1`.
• :code:`nav` is used for sections of links that direct users to different parts of your website. Commonly, this is used in a “navigation bar” at the top of a web page.
• :code:`main` This is for the body of your web page. There should only be one of these per page.
• :code:`header` and :code:`footer` These are common sections that you might include. They should be *outside* of the main content.
• :code:`section` should be used to group elements into a larger component, like a toolbar.

**Content elements** give meaningful descriptions to content that is primarily designed to
be read, such as text and graphics:

• :code:`p` is for a “paragraph”, which can include other elements inside, like :code:`img`, :code:`a`, and so on.
• :code:`strong` and :code:`em` for bold and italic text, respectively.
• :code:`time` is useful for dates and times, and many browsers give users additional features, like the ability to easily create a calendar link.

**Interactive elements** are those with which users interact, so they are perhaps the most important to target for accessibility.

• :code:`a` (“anchor”) links to another page or another part of the same page.
• :code:`button` is the main way to take some action. *When you use a button, the browser automatically provides functions for keyboard accessibility, as well as describing the button as “clickable” to a screen reader.*
• :code:`input` is the primary method for accepting user input, such as within a form. :code:`inputs` have a :code:`type` attribute that can take on one of 22 different values such as :code:`email`, :code:`password`, :code:`checkbox`, and so on.
• :code:`select` builds simple dropdown lists.

Buttons and inputs come with quite a few default features that are critical for accessibility.
However, each of these components can be controlled individually.

• *Focus*: An interactive element needs to be able to “receive focus”, which means that when a user is navigating a web page with a keyboard, they are able to take actions on a focused element. (This is analogous to how the styling of an element might change when you hover over it.) Focusability is controlled by the :code:`tabindex` attribute. Native elements like a :code:`button` have a property :code:`tabindex="0"` internal to them. If you’re trying to make a span interactive, you’ll need to take care to manually set this.
• *Keyboard Actions*: When a button or link has focus, a button is activated when Enter or Space is pressed, but links are followed only when Enter is pressed. When adding interactivity to other element types, take care to add an :code:`onkeypress` event handler that responds to the appropriate keys. The keypress handler will often call the :code:`onclick` handler, mirroring the behavior of the built-in :code:`button`.
• *Visual Focus*: Using the :code:`:focus` CSS pseudo-selector allows styling an element differently when it has focus, so that when users tab with the keyboard they can see which element is active.

A corollary of the Semantic HTML guideline of using the most appropriate element for a given task is that you shouldn’t 
deliberately make non-interactive elements interactive unless you have no other alternatives, such as having a plain :code:`p` 
(paragraph) element respond to clicks. Instead, find a way to achieve your goal using existing interactive elements such as 
buttons and links.

Going beyond using Semantic HTML to select the right elements, we can further improve accessibility using **WAI-ARIA**, or simply 
ARIA: The Web Accessibility Initiative/Accessible Rich Internet Applications specification stewarded by the World Wide Web 
Consortium (W3C), which specifies how to increase the accessibility of web pages, in particular those enhanced by JavaScript.

The first rule of ARIA is “Don’t use ARIA”—that is, try to structure your HTML and JavaScript so that the additional support 
ARIA provides is unnecessary. ARIA is a purely *descriptive* tool: Adding ARIA attributes to an element will not change how the 
element *works*, but only how it is read aloud by the screen reader. ARIA applies to both interactive and non-interactive 
elements.

In ARIA, every HTML element has a *role* and a *label*. The ARIA specification defines the allowed roles. Many roles such as 
:code:`link` and :code:`button` follow from the HTML element type itself, but others describe more complex UI elements such as “tooltip” 
that do not correspond directly to a specific HTML element type.

The label, sometimes called an *accessible name*, is typically generated from the visual text of the element, and sometimes 
includes the role. For example a button (:code:`<button>Submit</button>`) might be read as “Submit, button” by a screen reader. 
But when there is no text content in an interactive element, such as button whose content is an icon, for accessibility 
you *must* provide a label using ARIA. For example, adding the attribute :code:`aria-label="add to cart"` to an element will cause 
the screen reader to read the phrase “add to cart.” Labels should be detailed enough to convey the element’s purpose, but 
as concise as possible.

Finally, in this chapter we’ve seen many examples of how JavaScript can “live-update” the page’s DOM (and therefore the rendered 
HTML) after the page has been loaded, even if the user doesn’t do anything, as in the case of a page change triggered by a 
timer event. But if a page doesn’t specify when and where content might be updated, then screen-reader users might not realize 
something has changed. Adding the :code:`aria-live` attribute to an element tells a screen reader to notify the user when the content 
in that element changes. Most often, you should use :code:`aria-live="polite"`, which tries to minimize interruptions to the user, 
but in special cases, you can use :code:`aria-live="assertive"` to convey an urgent message.

Although mature HTML/CSS frameworks such as Bootstrap include appropriate ARIA notations on the elements and components they 
provide, accessibility is an ongoing concern during app development. The Web Content Accessibility Guidelines WCAG are the
requirements that applications need to follow to be considered legally accessible in many jurisdictions. The :code:`axe` browser 
extension, available for Chrome and Firefox, runs numerous checks for WCAG 2 compliance on any displayed page. Similarly, 
the W3C maintains the ARIA Authoring Practices specification, which contains dozens of examples (with working JavaScript) 
for common UI patterns across applications.