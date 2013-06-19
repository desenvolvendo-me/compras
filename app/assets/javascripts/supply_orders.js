function setModalUrlToLicitationProcess() {
  var urlModal = Routes.modal_licitation_processes,
      params = {
        by_ratification_and_year: $('#supply_order_year').val(),
        licitation_process: { year: $('#supply_order_year').val() },
        locked_fields: ['year']
      };

  urlModal += "?" + $.param(params);
  $('#supply_order_licitation_process').data('modal-url', urlModal);
}

function setModalUrlToCreditor() {
  var urlModal = Routes.modal_creditors,
      params = {
        by_ratification_and_licitation_process_id: $('#supply_order_licitation_process_id').val()
      };

  urlModal += "?" + $.param(params);
  $('#supply_order_creditor').data('modal-url', urlModal);
}

function getRatificationItems(licitationProcessId) {
  var ratificationItemsUrl = Routes.licitation_process_ratification_items,
      params = {
        licitation_process_id: licitationProcessId,
        creditor_id: $("#supply_order_creditor_id").val()
      };

  $.getIndex(ratificationItemsUrl, params, function(ratification_items) {
    fillSupplyOrderQuantities(ratification_items);
  });
}

function fillSupplyOrderQuantities(ratification_items) {
  var target           = $('div#supply_order_items'),
      templateValue    = $('#supply_order_items_value_template'),
      templateQuantity = $('#supply_order_items_quantity_template');

  target.empty();

  _.each(ratification_items, function(ratification_item) {
    var defaults = { uuid_item: _.uniqueId('fresh-') };
    var options  = $.extend({}, defaults, ratification_item);

    if (ratification_item.control_amount) {
      target.append(templateQuantity.mustache(options));
    } else {
      target.append(templateValue.mustache(options));
    };
  });
}

$(document).ready(function() {
  setModalUrlToLicitationProcess();
  setModalUrlToCreditor();

  $('form.supply_order').on('change', '#supply_order_year', function() {
    setModalUrlToLicitationProcess();
  });

  $('form.supply_order').on('change', '#supply_order_licitation_process_id', function() {
    setModalUrlToCreditor();
  });

  $('#supply_order_licitation_process').on('change', function (event, licitation_process) {
    if(licitation_process){
      $("#supply_order_modality_or_type_of_removal").val(licitation_process.modality_or_type_of_removal);
    } else {
      $("#supply_order_modality_or_type_of_removal, #supply_order_creditor").val('');
    }
  });

  $('#supply_order_creditor_id').on('change', function (event, creditor) {
    if(creditor){
      getRatificationItems($('#supply_order_licitation_process_id').val());
    }
  });
});
