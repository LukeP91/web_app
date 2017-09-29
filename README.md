# Web app

This app consists of two sub-apps.

First one allows users to register under one of available organizations and provide some basic information about them together with theirs interests.

Second part is admin panel that allows admin to register new users under his organization and edit already existing ones.
Admin can also send welcome email to all users in his organization or send welcome email or sms to given user.
In addition admin can add twitter's hash tags (sources) for which app will fetch tweets and later post them on Facebook's wall.
Admin has access to some statistics both for fetched tweets and registered users. He can find out most common words occurring in all tweets or for tweets from selected hash tag and number of tweets with given hashtags. As for users statistics he can see how many female users age 20-30 have health interests and users count groupe by age ranges (childs, teens, adults and elders).

Additionally application provides API (jsonapi standard) with JWT Token authentication that allows admins to get all users in theirs organization, fetch information about specific users, create new one or update already existing one.
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
