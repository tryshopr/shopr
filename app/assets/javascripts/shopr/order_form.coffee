$ ->

  toggleDeliveryFieldsetForOrder = ->
    fieldset = $('form.orderForm fieldset.delivery')
    if $('form.orderForm input#order_separate_delivery_address').prop('checked') then fieldset.show() else fieldset.hide()
  
  
  #
  # Setup the order form
  #
  setupForOrderForm = (form)->
    # All select boxes should use Chosen
    $('select', form).chosen({allow_single_deselect: true})
    # Changes to inputs should reload
    $('select, table.orderItems input', form).on 'change', -> refreshOrderDetails $(this).parents('form'), $(this).attr('id')
    # Callback for the separate address
    $('input#order_separate_delivery_address', form).on 'change', toggleDeliveryFieldsetForOrder
  
  # 
  # Automatically set up the form on page load if one exists.
  #
  if $('form.orderForm').length
    setupForOrderForm $('form.orderForm')
    toggleDeliveryFieldsetForOrder()
  
  #
  # Refresh the order
  #
  refreshOrderDetails = (form, invokeField)->
    $('input', form).prop('readonly', true).addClass('disabled')
    $.ajax
      url:        form.attr('action')
      method:     if $('input[name=_method]', form).length then $('input[name=_method]', form).val() else form.attr('method')
      data:       form.serialize()
      dataType:   'html'
      success: (html)->
        focusedField = $(':focus', form).attr('id')
        focusedField = invokeField unless focusedField?
        console.log focusedField
        
        form.html $(html).find('form')
        toggleDeliveryFieldsetForOrder()
        setupForOrderForm form
        $('div.moneyInput input', form).each formatMoneyField
        if focusedField?
          $("##{focusedField}").focus().trigger("chosen:activate")
          