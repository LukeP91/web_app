# recruitment-web-app
This is a spec for a candidate evaluation app.

## App requirements

### DONE
1. After navigating to the root directory using a web browser, the app should display a login page. If the user is logged in, then user listing is being displayed.
  Hint: it is usually a good idea to use a gem / working component to solve "standard" problems for a web app. In this context: https://github.com/plataformatec/devise

1.5 Add profile for user. Allow user to edit his profile.

2. Userbase consists of two types of users: regular and admin.
  Hint: Do not overcomplicate this. Also stuff that may come handy later: https://github.com/ryanb/cancan or https://github.com/elabs/pundit

3. Admins can see a trash can icon next to each user on the listing. They can click it and delete an user. Admin should not be able to delete himself/herself. The listing includes the following information: email, gender, age, interests. Requirement: Interests is a separate table. User can have many interests in terms of AR association defined on the model level. Hence, the interest should belong to an user.

4. Admin can see a link "navigate to the admin panel" somewhere on the page. He can click the link to display that page (accessible only by admins). Do not use rails_admin or similar gems.

5. In the admin panel there is a form, where an email, gender, age, interests can be specified for new and existing users. Requirement: the form should offer a possibility to dynamically specify the interest for the user, by adding additional fields to the form, without reloading the page. Each interest can have a name and a type (from the predefined collection of: ["health", "hobby", "work"]). When it comes to the number of interests, user can have any amount. New users created by admin should have a password set to "secret".
  Hint: https://github.com/ryanb/nested_form or https://github.com/nathanvda/cocoon

6. The admin panel should display a number which shows the amount of interests in the system of "health" type, chosen by women aged between 20 and 30, and the names of interests should start with "cosm". The query should be written using SQL or appriopriate DSL offered for instance by ActiveRecord. Usng Ruby for data manipualtion here is a faux pas. In other words, show me your SQL magic. Requirement: you should write a query with a subquery for this task.

7. On the regular users listing, admin can see a button "Export to CSV". After clicking a link, user gets a csv file with exported users. Hint https://www.ruby-toolbox.com/categories/reporting however you don't have to use any external gem. Feel free to use https://ruby-doc.org/stdlib-2.0.0/libdoc/csv/rdoc/CSV.html

8. On the user listing, everybody can see a mailbox icon. Everyone can click it. A click triggers an action where the email is being sent to the target user with content "current_user_email sends his regards". The recipient is of course the target user.   Requirement: use Service Object pattern to implement the email sending functionality. Hint: https://rubygems.org/gems/mailcatcher/versions/0.6.1

9. On the user listing there should be a search_field so users should be able to scope the listing by inputing the email. Bonus points for considering SQL injections while developing the feature. Hint: https://github.com/activerecord-hackery/ransack

* add seeds with 1000 users.

* It serves server side rendered pages

* It has at least one custom rake task:
  * move seeds to rake task with organization name

* 5 models with relations to each other
  * At least one n-n relation

* Add page object tests to project and add unit tests to statistic logic. Include test for search by first and last name. Age.

### Extra tasks
* It provide full text search (can be PostgreSQL FTS)
  * Expand search to first name, last name, age
  * Try PostgreSQL full-text search function

* It uses queues (e.g. Sidekiq):
  * Send welcome email to all. User Resque https://github.com/resque/resque. Button at the top of users table.
  * Async request for sending email.
  * Invitation email
  * Change regards email to async email

* Three 3rd party integrations
  * Sending Email / SMS (Send welcome SMS)
  * Synchronization of Data between APIs (Every 6 hours synchronize data with Facebook events. Every 6 hours update statistics about fetched events)
  * One without ready to use wrapper (HTTParty only) ( Search for open JSON API without rails-ready wrapper)

* It serves json api (in jsonapi or graphql standard) ( Add endpoint for users) [http://jsonapi.org/]
* Authentication & Authorization (session and token based) (Together with jsonapi)

* add readme to project

## How to get started aka the workflow requirements
1. Download the repo and upload it as your own. Do not fork it.
2. Add your evaluator as a contributor to your repository clone, so he or she can review pull requests.
3. Implement each requirement in a separate commit. The app should work according to the spec describe in each stage. So if somebody does `git reset --hard <stage>`, he will encounter no problems with the given app version.
4. Each stage of the app development should be presented as a pull request. You can skip this requirement, work alone and present only a final solution. However there are bonus points for showing us that you can work using PR workflow.
5. We love when a project has a test suite. Here is a hint: http://www.relishapp.com/rspec/rspec-rails/docs/gettingstarted
6. The initial commit with a fresh rails application should be a separate one. In other words, do not commit the rails app code with the first requirement code.
7. Do not use gems providing CRUD managing capabilities like rails_admin.

# Good luck!
