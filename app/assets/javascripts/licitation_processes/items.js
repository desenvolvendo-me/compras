$(document).ready(function() {
  function hasItemAlreadyAdded(item) {
    var added = false;
    $('#items-records input.material-id').each(function() {
      if ( $(this).val() == item.material_id ) {
        added = true;
      }
    });

    return added;
  }

  function mergeItem(item) {
    var material       = $('#items-records input.material-id[value="' + item.material_id + '"]'),
        record         = material.closest('.nested-record'),
        itemQuantity   = new BigNumber(parsePtBrFloat( record.find('input.item-quantity').val() )),
        itemTotalValue = new BigNumber(parsePtBrFloat( record.find('input.item-total-value').val() ))
        totalQuantity  = numberWithDelimiter(parseFloat( itemQuantity.add(item.quantity) )),
        totalValue     = numberWithDelimiter(parseFloat( itemTotalValue.add(item.estimated_total_price) ));

    record.find('input.item-quantity').val(totalQuantity);
    record.find('td.item-quantity').text(totalQuantity);

    record.find('input.item-total-value').val(totalValue);
    record.find('td.item-total-value').text(totalValue);
  }

  function renderItem(item) {
    var itemBinds = {
      uuid: _.uniqueId('fresh-'),
      lot: '1',
      material_id: item.material_id,
      material: item.material_description,
      reference_unit: item.reference_unit,
      quantity: numberWithDelimiter(item.quantity),
      unit_price: numberWithDelimiter(item.unit_price),
      estimated_total_price: numberWithDelimiter(item.estimated_total_price)
    };

    $('#items-records tbody').append( $('#licitation_process_items_template').mustache(itemBinds) )
                             .trigger("nestedGrid:afterAdd");
  }

  $('form.licitation_process').on('keyup', '#licitation_process_unit_price, #licitation_process_quantity', function() {
    var itemQuantity  = new BigNumber(parsePtBrFloat( $('#licitation_process_quantity').val() || '0')),
        itemUnitPrice = new BigNumber(parsePtBrFloat( $('#licitation_process_unit_price').val() || '0')),
        total         = numberWithDelimiter(parseFloat(itemQuantity.multiply(itemUnitPrice)));

    $('#licitation_process_estimated_total_price').val(total);
  });

  $('form.licitation_process').on('keyup', '#licitation_process_estimated_total_price', function() {
    var itemQuantity = new BigNumber(parsePtBrFloat( $('#licitation_process_quantity').val() || '0')),
        itemPrice    = new BigNumber(parsePtBrFloat( $('#licitation_process_estimated_total_price').val() || '0')),
        unitPrice    = numberWithDelimiter(0);

    if (itemQuantity != '0') {
      unitPrice = itemPrice.divide(itemQuantity);
      unitPrice = numberWithDelimiter(parseFloat(unitPrice));
    }

    $('#licitation_process_unit_price').val(unitPrice);
  });

  $("#licitation_process_purchase_solicitations_id").on("change", function(event, purchaseSolicitation) {
    if (!purchaseSolicitation) {
      purchaseSolicitation = {};
    }

    $.each(purchaseSolicitation.items, function(i, item) {
      if ( hasItemAlreadyAdded(item) ) {
        mergeItem(item);
      } else {
        renderItem(item);
      }
    });
  });

  $('#licitation_process_material_id').on('change', function(event, material) {
    if (material){
      $('#licitation_process_reference_unit').val(material.reference_unit);
    }
  });

  $("#items_tab_header").on('click', function(){
    var isDirectPurchase = $('#licitation_process_type_of_purchase_direct_purchase').is(':checked');

    if ( isDirectPurchase ) {
      $('.item-creditor').removeClass('hidden');
      $('#licitation_process_creditor').requiredField(true);
      $('input.creditor-id').attr('disabled', false);
    } else {
      $('.item-creditor').addClass('hidden');
      $('#licitation_process_creditor').requiredField(false);
      $('input.creditor-id').attr('disabled', true);
    }
  });

  if ( $("#licitation_process_purchase_solicitation_id").val() ) {
    var $inputs = $("#items .nested-licitation-process-item :input"),
        $modals = $("#items .nested-licitation-process-item .modal");

    $inputs.attr("readonly", true);
    $inputs.attr("disabled", true);
    $modals.attr("disabled", true);
  }
});
