# Shopr

[![Build Status](https://travis-ci.org/tryshopr/shopr.svg)](https://travis-ci.org/tryshopr/shopr)
[![Gem Version](https://badge.fury.io/rb/shopr.svg)](http://badge.fury.io/rb/shopr)

Shopr is an Rails ecommerce engine which allows you to easily introduce a store into your Rails 5.2 applications.

Shopr is a rewrite of [Shoppe](https://github.com/tryshoppe/shoppe) (originally created by [Adam Cooke](http://twitter.com/adamcooke)) created by [Dean Perry](https://github.com/deanpcmad) and maintained by great group of [contributors](https://github.com/tryshopr/shopr/graphs/contributors).
While it supports many of the same features as Shoppe, its underlying implementation differs greatly and backwards compatibility is not a design goal.

**Shopr is currently still under development.**

## Features

- An attractive & easy to use admin interface with integrated authentication
- Full product/catalogue management
- Stock control
- Tax management
- Flexible & customisable order flow
- Delivery/shipping control, management & weight-based calculation

## Getting Started

Shopr provides the core framework for the store and you're responsible for creating
the storefront which your customers will use to purchase products. In addition to
creating the UI for the frontend, you are also responsible for integrating with whatever
payment gateway takes your fancy.

### Installing into a new Rails application

To get up and running with Shopr in a new Rails application is simple. Just follow the
instructions below and you'll be up and running in minutes.

```shell
rails new my_store
cd my_store
echo "gem 'shopr'" >> Gemfile
bundle
rails generate shopr:install:migrations
rake db:migrate shopr:setup
rails server
```

## Differences from Shoppe

- Devise is now used for authentication
- Tested with RSpec
- Product & Product Category translations have been removed

## Contribution

If you'd like to help with this project, please get in touch with me here on github. You are welcome with new PRs.

## License

Shopr is licenced under the MIT license. Full details can be found in the MIT-LICENSE
file in the root of the repository.

The original code for Shopr is forked from [Shoppe](https://github.com/tryshoppe/shoppe).
This was licensed as MIT from aTech Media.
