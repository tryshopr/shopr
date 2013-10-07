**This is still under very active development and I do not recommend using it
for anything at all at the moment. Anything could change and we will be releasing
an example store shortly.**

Shoppe is an Rails-based e-commerce platform which allows you to easily introduce a
catalogue-based store into your Rails 4 applications. 

![Admin UI](http://s.adamcooke.io/aMrVp.png)

## Features

* An attractive & easy to use admin interface with intergrated authentication
* Full product/catalogue management
* Stock control
* Delivery/shipping control, management & weight-based calculation

## Getting Started

Shoppe provides the core framework for the store and you're responsible for creating
the storefront which your customers will use to purchase products. In addition to
creating the UI for the frontend, you are also responsible for integrating with whatever
payment gateway takes your fancy.

### Installing into a new Rails application

To get up and running with Shoppe in a new Rails application is simple. Just follow the
instructions below and you'll be up and running in minutes.

```bash
# Create a new Rails skeleton application
rails new my_store
# Enter the store directory and add the Shoppe gem to the Gemfile
cd my_store
# Bundle
bundle
# Generate the shoppe configuration file and insert the engine into your routes
rails generate shoppe:setup
# Run migrations required by Shoppe's dependencies. If you already use either of
# these in your application, you can skip these as appropriate.
rails generate nifty:attachments:migration
rails generate nifty:key_value_store:migration
# Migrate your database and create a new default user
rake db:migrate shoppe:create_default_user
# Start the server
rails server
```

## License

Shoppe is licenced under the MIT license. Full details can be found in the MIT-LICENSE
file in the root of the repository.
