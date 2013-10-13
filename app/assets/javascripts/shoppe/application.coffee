#= require jquery
#= require jquery_ujs
#= require shoppe/jquery_ui
#= require_tree .

$ ->
  # Automatically focus all fields with the 'focus' class
  $('input.focus').focus()
  
  # When clicking the order search button, toggle the form
  $('a[rel=searchOrders]').on 'click', ->
    $('div.orderSearch').toggle()
  
  # Add a new attribute to a table
  $('a[data-behavior=addAttributeToAttributesTable]').on 'click', ->
    table = $('table.productAttributes')
    if $('tbody tr', table).length == 1 || $('tbody tr:last td:first input', table).val().length > 0
      template = $('tr.template', table).html()
      table.append("<tr>#{template}</tr>")
    false
  
  # Remove an attribute from a table
  $('table.productAttributes tbody').on 'click', 'tr td.remove a', -> 
    $(this).parents('tr').remove()
  
  # Sorting on the product attribtues table
  $('table.productAttributes tbody').sortable
    axis: 'y'
    handle: '.handle'
    cursor: 'move',
    helper: (e,tr)->
      originals = tr.children()
      helper = tr.clone()
      helper.children().each (index)->
        $(this).width(originals.eq(index).width())
      helper