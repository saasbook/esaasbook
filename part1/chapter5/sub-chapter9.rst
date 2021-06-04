Fallacies and Pitfalls
====================================

**Pitfall: Too many filters or model lifecycle callbacks, or overly complex logic in filters or callbacks.**

Filters and callbacks provide convenient and well-defined places to DRY out duplicated code, but too many of 
them can make it difficult to follow the app’s logic flow. For example, when there are numerous before-filters, 
after-filters and around-filters that trigger on different sets of controller actions, it can be hard to figure 
out why a controller action fails to execute as expected or which filter “stopped the show.” Things can be even 
worse if some of the filters are declared not in the controller itself but in a controller from which it inherits, 
such as :code:`ApplicationController`. Filters and callbacks should be used when you truly want to centralize code that 
would otherwise be duplicated.

**Pitfall: Not checking for errors when saving associations.**

Saving an object that has associations implies potentially modifying multiple tables. If any of those modifications 
fails, perhaps because of validations either on the object or on its associated objects, other parts of the save might 
silently fail. Be sure to check the return value of :code:`save`, or else use :code:`save!` and rescue any exceptions.

**Pitfall: Nesting resources more than 1 level deep.**

Although it’s technically possible to have nested resources multiple levels deep, the routes and actions quickly 
become cumbersome, which may be a sign that your design isn’t properly factored. Perhaps there is an additional 
entity relationship that needs to be modeled, using a shortcut such as :code:`has_many :through` to represent the 
final association.
