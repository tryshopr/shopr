# Shoppe

Shoppe is an Rails-based e-commerce platform which allows you to easily introduce a
catalogue-based store into your Rails 4 applications. 

**Note: the platform is still under constant development and the API has not yet been
finalised and functionality & features may change without notice. I do not recommend
using Shoppe for any production sites yet. I'm hoping to release a v1.0 version in the 
very near future which will have a stable API.**

![Build Status](https://travis-ci.org/tryshoppe/core.png?branch=master) ![GemVersion](https://badge.fury.io/rb/shoppe.png)

In the meantime, why not:

* [Check out the website](http://tryshoppe.com)
* [View the demo site](http://demo.tryshoppe.com)
* [Check out the demo site source](http://github.com/tryshoppe/example-store)
* [Read the release notes](https://github.com/tryshoppe/core/blob/master/CHANGELOG.md)
* [Read API documentation](http://api.tryshoppe.com)

## Features

* An attractive & easy to use admin interface with intergrated authentication
* Full product/catalogue management
* Stock control
* Tax management
* Flexible & customisable order flow
* Delivery/shipping control, management & weight-based calculation

## Getting Started

Shoppe provides the core framework for the store and you're responsible for creating
the storefront which your customers will use to purchase products. In addition to
creating the UI for the frontend, you are also responsible for integrating with whatever
payment gateway takes your fancy.

### Installing into a new Rails application

To get up and running with Shoppe in a new Rails application is simple. Just follow the
instructions below and you'll be up and running in minutes.

    rails new my_store
    cd my_store
    echo "gem 'shoppe'" >> Gemfile
    bundle
    rails generate shoppe:setup
    rails generate nifty:attachments:migration
    rails generate nifty:key_value_store:migration
    rake db:migrate shoppe:setup
    rails server

## License

Shoppe is licenced under the MIT license. Full details can be found in the MIT-LICENSE
file in the root of the repository.
