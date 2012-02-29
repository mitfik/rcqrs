# Ruby CQRS with Event Sourcing

A Ruby implementation of Command-Query Responsibility Segregation (CQRS) with Event Sourcing, based upon the ideas of [Greg Young](http://codebetter.com/blogs/gregyoung/).

[Find out more about CQRS](http://cqrsinfo.com/).

## Getting Started

Dependencies are managed using [Bundler](http://gembundler.com/).

    $ sudo gem install bundler

Install all of the required gems for this application

    $ sudo bundle install

## Specs

Run the RSpec specifications as follows.

    $ rspec spec/

## Basic Design Overview

###UI

- display query results using read-only reporting datastore
- create commands - must be 'task focused'
- basic validation of command (e.g. required fields, uniqueness using queries against the reporting data store)

###Commands
such as `RegisterCompanyCommand`

- capture users’ intent
- named in the imperative (e.g. create account, upgrade customer, complete checkout)
- can fail or be declined

###Command Bus

- validates command
- routes command to registered handler (there can be only one handler per command)

###Command Handler 
such as `RegisterCompanyHandler`

- loads corresponding aggregate root (using domain repository)
- executes action on aggregate root
  
###Aggregate Roots
such as `Company`

- guard clause (raises exceptions when invalid commands applied)
- calculations (but no state changes)
- create & raise corresponding domain events
- subscribes to domain events to update internal state

###Domain Events
such as `CompanyRegisteredEvent`

- inform something that has already happened
- must be in the past tense and cannot fail
- used to update internal state of the corresponding aggregate root

###Event Bus

- subscribes to domain events
- persist domain events to event store
- routes events to registered handler(s) (can have more than one handler per event)

###Event Handler
such as `CompanyRegisteredHandler`

- update de-normalised reporting data store(s)
- email sending
- execute long running processes (e.g. 3rd party APIs, file upload)

###Event Store

- persists all domain events applied to each aggregate root (stored as JSON)
- reconstitutes aggregate roots from events (from serialised JSON)
- currently two adapters: ActiveRecord and in memory (for testing)
- adapter interface is 2 methods: `find(guid)` and `save(aggregate_root)`
- could be extended to use a NoSQL store

## Setting 

There is possibility to configure rcqrs-rails. Right now there is just 2 options: orm and file path for example:

   Rcqrs::Setting.set do |setting| 
     setting.default_orm = :in_memory 
     setting.default_database_file_path = "config/database_event_store.yml" 
   end

### Rails 
  If You will use dm-rails You need to put all config to config/database.yml to make sure that all rake will be work for You.
  You can put it for example in config/initializer/rcqrs.rb

### Other
  You can put it wherever You want :) 

## Warning !!!

You must remmber that You CAN NOT give the same name for event handler as for command handler, first because it's not properly, second app will crash :)
