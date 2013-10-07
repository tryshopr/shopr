**This is still under very active development and I do not recommend using it
for anything at all at the moment. Anything could change and we will be releasing
an example store shortly.**

Shoppe is an Rails-based e-commerce platform which allows you to easily introduce a
catalogue-based store into your Rails 4 applications. 

![Admin UI](http://s.adamcooke.io/aMrVp.png)

Shoppe provides the core framework for the store and you're responsible for creating
the storefront which your customers will use to purchase products. In addition to
creating the UI for the frontend, you are also responsible for integrating with whatever
payment gateway takes your fancy.

## Features

* Product management
* Stock control
* Delivery service management
* A full admin interface with intergrated authentication

## Installing Shoppe into a new Rails application

To get up and running with Shoppe in a new Rails application is simple. Just follow the
instructions below and you'll be up and running in minutes.

```
$ rails new my_store
$ cd my_store
# Add "gem 'shoppe'" to your Gemfile
$ bundle
$ rails generate shoppe:setup
$ rails generate nifty:attachments:migration
$ rails generate nifty:key_value_store:migration
$ rake db:migrate shoppe:create_default_user
$ rails server
```
