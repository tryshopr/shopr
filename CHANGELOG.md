# Shoppe Release Notes

This document outlines key changes which are introduced in each version. The full commit history can be found [on GitHub](http://github.com/tryshoppe/core).

## v0.0.15 - The break everything release

* **Breaking change:** The `Shoppe::OrderItem` model no longer responds to `product` as part 
  of a change to allow items other than products to be ordered. Order items will now respond
  to `ordered_item` which is a polymorphic association to any model which implements the 
  `Shoppe::OrderableItem` protocol (see /lib/shoppe/orderable_item.rb). Base applications
  which work with this will need to be updated to use this new association name. Also, the
  `Shoppe::OrderItem.add_product` has been renamed to `Shoppe::OrderItem.add_item`.

* **Breaking change:** `Shoppe::Product#title` has been renamed to `Shoppe::Product#name`
  as title was a stupid name for a product. Base application will need to use `name` to 
  display the name of a product.
  
* **Breaking change:** `Shoppe::StockLevelAdjustment` is now polymorphic rather than only
  beloning to a product. `StockLevelAdjustment#product` has been replaced with 
  `StockLevelAdjustment#item`. This shouldn't require any adjustments to base applications
  unless they interact with the stock level adjustments model directly.

## v0.0.14

* Fixes serious styling issue with the user form.

## v0.0.13

* Orders have notes which can be viewed & editted through the Shoppe UI.
* Adjustments to the design in the Shoppe UI.

## v0.0.12

* Don't persist order item pricing until the order is confirmed. While an order is being built
  all prices will be calculated live from the parent product and these values will be persisted
  (in case of any future changes to the product) at the point of confirmation. This makes way for
  changes to the tax rates based on order itself to be introduced.

## v0.0.11

* All countries are now stored in the database which will allow for delivery & tax rate decisions to
  be made as appropriate. There is now no need to use things like `country_select` in applications.
  Any existing order which has a country will have this data lost. A rake task method is provide to
  allow a default set of countries to be imported (`rake shoppe:import_countries`). There is
  currently no way to manage countries from the Shoppe interface.

* Items with prices are now assigned to a `Shoppe::TaxRate` object rather than specifying a
  percentage on each item manually. This allows rates to be changed globally and allows us to change
  how tax should be charged based
  on other factors (country?).

## v0.0.10

* Improved stock control so that a journal is kept of all stock movement in and out of the system.
  There is no need to make any changes to your application however all existing stock levels will be
  removed when upgrading to this version.
