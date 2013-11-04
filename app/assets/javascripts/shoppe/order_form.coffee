$ ->

  toggleDeliveryFieldsetForOrder = ->
    fieldset = $('form.orderForm fieldset.delivery')
    if $('form.orderForm input#order_separate_delivery_address').prop('checked') then fieldset.show() else fieldset.hide()
    
  $('form.orderForm').on 'change', 'input#order_separate_delivery_address', toggleDeliveryFieldsetForOrder
  toggleDeliveryFieldsetForOrder()
  
  setupForOrderForm = (form)->
    $('select', form).chosen({allow_single_deselect: true})
    $('select, table.orderItems input', form).on 'change', ->
      refreshOrderDetails $(this).parents('form')
    
  if $('form.orderForm').length
    setupForOrderForm($('form.orderForm'))
  
  refreshOrderDetails = (form)->
    $.ajax
      url:        form.attr('action')
      method:     if $('input[name=_method]', form).length then $('input[name=_method]', form).val() else form.attr('method')
      data:       form.serialize()
      dataType:   'html'
      success: (html)->
        focusedField = $(':focus', form).attr('id')
        form.html($(html).find('form'))
        toggleDeliveryFieldsetForOrder()
        setupForOrderForm(form)
        $('div.moneyInput input', form).each formatMoneyField
        if focusedField?
          $("##{focusedField}").focus()
  
  