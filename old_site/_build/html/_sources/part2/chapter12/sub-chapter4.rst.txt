Releases and Feature Flags 
====================================
As we discussed way back in Section 1.2, prior to SaaS, software releases were major 
and infrequent milestones after which product maintenance responsibility passed largely 
to the Quality Assurance or Customer Service department. In contrast, Many Agile companies 
deploy new versions frequently (sometimes several times *per day*) and the developers stay 
close to operations and to customer needs.

In Agile development, making deployment a *non*-event requires complete automation, so 
that typing one command triggers all the actions to deploy a new version of the software, 
including cleanly aborting the deploy without modifying the released version if anything 
goes wrong. As with iteration-based TDD and BDD, by deploying frequently you become good 
at it, and by automating deployment you ensure that it’s done consistently every time.

Although deployment is a non-event, there is still a role for release milestones: they 
reassure the customer that new work is being deployed. For example, a customer-requested 
feature may require multiple commits to implement, each of which may include a deployment, 
but the overall feature remains “hidden” in the user interface until all changes are completed. 
“Turning on” the feature would be a useful release milestone. For this reason, many 
continuous-deployment workflows assign distinct and often whimsical labels to specific release 
points (such as “Bamboo” and “Cedar” for Heroku’s software stacks), but just use the Git 
commit-id to identify deployments that don’t include customer-visible changes.

Of course, deployment can only be successful if the app is well tested and stable in 
development. Although we’ve already focused heavily on testing in this book, making deployment 
a true non-event requires meeting two additional challenges: deployment testing and 
incremental feature roll-out.

Beyond traditional CI, deployment testing must account for differences between the development 
and production environments, such as the type of database used or the need for 
JavaScript-intensive apps to work correctly on a variety of browser versions. Deployment testing 
should also test the app in ways it was *never* meant to be used—users submitting non-sensical 
input, browsers disabling cookies or JavaScript, miscreants trying to turn your site into a 
distributor of **malware** (as we describe further in Section 12.9)—and ensuring that it survives 
those conditions without compromising customer data or responsiveness.

The second challenge is the roll-out of complex features that may require several code pushes, 
especially features that require database schema changes. In particular, a challenge arises when 
the new code does not work with the old schema and vice-versa. To make the example concrete, 
suppose RottenPotatoes currently has a :code:`moviegoers` table with a :code:`name` column, but we want to 
change the schema to have separate :code:`first_name` and :code:`last_name`
columns instead. If we change the schema before changing the code, the app will break because 
methods that expect to find the :code:`name` column will fail. If we change the code before changing 
the schema, the app will break because the new methods will look for :code:`first_name` and :code:`last_name` 
columns that don’t exist yet.

We could try to solve this problem by deploying the code and migration **atomically**: take the 
service offline, apply the migration to perform the schema change and copy the data into the 
new column, and bring the service back online. This approach is the simplest solution, but may 
cause unacceptable unavailability: a complex migration on a database of hundreds of thousands 
of rows can take tens of minutes or even hours to run.

.. code-block:: ruby
    :linenos:

    /* in code paths for functionality that searches the database: */
    if (featureflag is on)
        results = union(query using old schema, query using new schema)
    else /* featureflag is off */
        results = (query using old schema)
    end

    /* in code paths that write to the database */
    if (featureflag is on)
        if (data to be written is still using old schema)
            (convert existing record from old to new schema)
            (mark record as converted)
        end  
        (update data according to new schema)
    else
        (update data according to old schema)
    end

The second option is to split the change across multiple deployments using a *feature* *flag*—a configuration 
variable whose value can be changed *while the app is running* to control which code paths in 
the app are executed. Notice that each step in Figure 12.3 is nondestructive: as we did with 
refactoring in Chapter 9, if something goes wrong at a given step, the app is still left in a 
working intermediate state. Figure 12.3 illustrates schematically how to do this:


1. Create a migration that makes only those changes to the schema that *add* new tables or columns, including a column indicating whether the current record has been migrated to the new schema or not.
2. Create version :math:`n+1` of the app in which every code path affected by the schema change is split into two code paths, of which one or the other is executed based on the value of a *feature flag*. Critical to this step is that correct code will be executed regardless of the feature flag’s value at any time, so the feature flag’s value can be changed without stopping and restarting the app; typically this is done by storing the feature flag in a special database table.
3. Deploy version :math:`n+1`, which may require pushing the code to multiple servers, a process that can take several minutes.
4. Once deployment is complete (all servers have been updated to version :math:`n+1` of the code), while the app is running set the feature flag’s value to True. Essentially, each record will be migrated to the new schema the next time it’s modified for any reason. If you wanted to speed things up, you could also run a low-traffic background job that opportunistically migrates a few records at a time to minimize the additional load on the app, or migrates many records at a time during hours when the app is lightly loaded, if any. If something goes wrong at this step, turn off the feature flag; the code will revert to the behavior of version :math:`n`, since the new schema is a proper superset of the old schema and the :code:`before_save` callback is nondestructive (that is, it correctly updates the user’s name in both the old and new schemata).
5. If all goes well, once all records have been migrated, deploy code version :math:`n+2`, in which the feature flag is removed and only the code path associated with the new schema remains.
6. Finally, apply a new migration that removes the old :code:`name` column and the temporary :code:`migrated` column (and therefore the index on that column).

What about a schema change that modifies a column’s name or format rather than adding or 
removing columns? The strategy is the same: add a new column, remove the old column, and if 
necessary rename the new column, using feature flags during each transition so that every 
deployed version of the code works with both versions of the schema.

**Self-Check 12.4.1.** *Which of the following are appropriate places to store the value of a simple 
Boolean feature flag and why: (a) a YAML file in the app’s* :code:`config` *directory, (b) a column in an 
existing database table, (c) a separate database table?*

    The point of a feature flag is to allow its value to be changed at runtime without modifying 
    the app. Therefore (a) is a poor choice because a YAML file cannot be changed without touching 
    the production servers while the app is running.