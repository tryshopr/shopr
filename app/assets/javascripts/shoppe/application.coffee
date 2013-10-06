#= require jquery
#= require jquery_ujs
#= require_tree .

$ ->
  $('input.focus').focus()
  $('a[rel=searchOrders]').on 'click', ->
    $('div.orderSearch').toggle()