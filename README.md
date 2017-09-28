# Web app

* App allows users to register under theirs organization and share with others their interests. In addition admin can add twitter's hash tags from which app will fetch tweets and later post them on Facebook's wall.

## Prerequisites

#### Environment

* Ruby version: 2.4.0
* Rails 5.0.5
* PostgreSQL
* Sidekiq
* Redis
* Template Engine: Haml
* Testing Framework: RSpec, Factory Girl
* Authentication: Devise
* Authorization: Pundit

#### Database setup

* run `db:create db:migrate`
* to set seeds run `rails "db:populate [organization_name, organization_subdomain, admin_email, admin_password]"`

## Testing

#### Running tests

* run `rspec`

#### Twillio testing

* Full testing of Twillio requires manual test that sends message to phone number of given user.

#### Test accounts

* Tests accounts are created during application setup with data provided by user.
