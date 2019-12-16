function setModalUrlToPurchaseSolicitation() {
    var urlModal = Routes.modal_purchase_solicitations,
        params = {
            by_licitation_process: $('#supply_order_licitation_process_id').val()
        };

    urlModal += "?" + $.param(params);
    $('#supply_order_purchase_solicitation').data('modal-url', urlModal);
}

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

function setPledgeSource() {
  var url = Routes.pledges,
      params = {
        by_purchase_process_id: $('#supply_order_licitation_process_id').val()
      };

  url += "?" + $.param(params);
  $('#supply_order_pledge').data('source', url);
}

function getPledgeItems(pledgeId) {
  var pledgeItemsUrl = Routes.pledge_items,
      params = {
        by_pledge_id: pledgeId
      };

  $.getIndex(pledgeItemsUrl, params, function(pledge_items) {
    fillSupplyOrderQuantities(pledge_items);
  });
}

function fillSupplyOrderQuantities(pledge_items) {
  var target           = $('div#supply_order_items'),
      templateValue    = $('#supply_order_items_value_template'),
      templateQuantity = $('#supply_order_items_quantity_template');

  target.empty();

  _.each(pledge_items, function(pledge_item) {
    var defaults = { uuid_item: _.uniqueId('fresh-') };
    var options  = $.extend({}, defaults, pledge_item);

    if (pledge_item.service_without_quantity) {
      target.append(templateValue.mustache(options));
    } else {
      target.append(templateQuantity.mustache(options));
    }
  });
}

$(document).ready(function() {
  setModalUrlToLicitationProcess();
  setModalUrlToCreditor();
  setPledgeSource();
  setModalUrlToPurchaseSolicitation();

  $('form.supply_order').on('change', '#supply_order_year', function() {
    setModalUrlToLicitationProcess();
  });

  $('form.supply_order').on('change', '#supply_order_licitation_process_id', function() {
    setModalUrlToCreditor();
    setPledgeSource();
    setModalUrlToPurchaseSolicitation();
  });

  $('#supply_order_licitation_process').on('change', function (event, licitation_process) {
    if(licitation_process){
      $("#supply_order_modality_or_type_of_removal").val(licitation_process.modality_or_type_of_removal);
      $("#supply_order_purchase_solicitation").attr('disabled',false);
    } else {
      $("#supply_order_modality_or_type_of_removal, #supply_order_creditor,#supply_order_purchase_solicitation_id").val('');
    }
  });

  $('#supply_order_pledge_id').on('change', function (event, pledge) {
    if(pledge){
      getPledgeItems(pledge.id);
    }
  });
});
