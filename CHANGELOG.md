# Shoppe Release Notes

This document outlines key changes which are introduced in each version. Each item is tagged as appropriate
and the full commit history can be found [on GitHub](http://github.com/tryshoppe/core).

## v0.0.11

* All countries are now stored in the database which will allow for delivery & tax rate decisions to
  be made as appropriate. There is now no need to use things like `country_select` in applications. Any existing
  order which has a country will have this data lost. A rake task method is provide to allow a default set of 
  countries to be imported (`rake shoppe:import_countries`).

## v0.0.10

* Improved stock control so that a journal is kept of all stock movement in and out of the system.
  There is no need to make any changes to your application however all existing stock levels will be removed when
  upgrading to this version.
