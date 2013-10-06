#= require jquery
#= require jquery_ujs
#= require_tree .

$ ->
  # Automatically focus all fields with the 'focus' class
  $('input.focus').focus()
  
  # When clicking the order search button, toggle the form
  $('a[rel=searchOrders]').on 'click', ->
    $('div.orderSearch').toggle()