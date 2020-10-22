//= require modal_filter
//= require input

function setModalUrlToContract() {
  var selector_modal = '#supply_request_contract';
  params = {
    purchase_process_id: $('#supply_request_licitation_process_id').val()
  };
  setModalUrl(selector_modal,'contracts',params);
}

function setModalUrlToPurchaseSolicitation() {
  var selector_modal = '#supply_request_purchase_solicitation';
  params = {
    by_licitation_process: $('#supply_request_licitation_process_id').val(),
    by_secretaries_permited: $('#current_user').val()
  };
  setModalUrl(selector_modal,'purchase_solicitations',params);
}

function setModalUrlToMaterial() {
  var selector_modal = '#supply_request_material';

  var licitation_process = $('#supply_request_licitation_process_id').val();
  var contract = $('#supply_request_contract_id').val();
  var creditor = $('#supply_request_creditor_id').val();
  var urlModal = Routes.materials,
      params = {
        material_of_supply_request: [licitation_process , contract, creditor]
      };

  if(licitation_process=='' || contract==''){
    $("#supply_request_material").attr('disabled', true);
  }else{
    urlModal += "?" + $.param(params);
    $(selector_modal).data('source', urlModal);
  }

}

function setModalUrlToCreditor() {
  var urlModal = Routes.modal_creditors,
      params = {
        by_ratification_and_licitation_process_id: $('#supply_request_licitation_process_id').val()
      };

  urlModal += "?" + $.param(params);
  $('#supply_request_creditor').data('modal-url', urlModal);
}

function setPledgeSource() {
  var url = Routes.pledges,
      params = {
        by_purchase_process_id: $('#supply_request_licitation_process_id').val()
      };

  url += "?" + $.param(params);
  $('#supply_request_pledge').data('source', url);
}

function getPledgeItems(pledgeId) {
  var pledgeItemsUrl = Routes.pledge_items,
      params = {
        by_pledge_id: pledgeId
      };

  $.getIndex(pledgeItemsUrl, params, function (pledge_items) {
    fillSupplyRequestQuantities(pledge_items);
  });
}

function fillSupplyRequestQuantities(pledge_items) {
  var target = $('div#supply_request_items'),
      templateValue = $('#supply_request_items_value_template'),
      templateQuantity = $('#supply_request_items_quantity_template');

  target.empty();

  _.each(pledge_items, function (pledge_item) {
    var defaults = {uuid_item: _.uniqueId('fresh-')};
    var options = $.extend({}, defaults, pledge_item);

    if (pledge_item.service_without_quantity) {
      target.append(templateValue.mustache(options));
    } else {
      target.append(templateQuantity.mustache(options));
    }
  });
}

function setDepartment() {
  var purchase_solicitation_id = $('#supply_request_purchase_solicitation_id').val()

  if (purchase_solicitation_id) {
    $.ajax({
      url: Routes.purchase_solicitation_department,
      data: {purchase_solicitation_id: purchase_solicitation_id},
      dataType: 'json',
      type: 'GET',
      success: function (data) {
        $('#purchase_solicitation_department').val(data["description"]);
      }
    });
  }
}

function setMaterialTotalAndBalance() {
  var licitation_process_id = $('#supply_request_licitation_process_id').val();
  var material_id = $('#supply_request_material_id').val();
  var purchase_solicitation_id = $('#supply_request_purchase_solicitation_id').val();
  var contract_id = $('#supply_request_contract_id').val();
  var supply_request_id = $(window.location.href.split("/")).get(-2);
  var quantity = $('#supply_request_requested_quantity').val();

  if (licitation_process_id && purchase_solicitation_id && material_id && quantity) {
    $.ajax({
      url: Routes.licitation_process_material_total_balance,
      data: {
        licitation_process_id: licitation_process_id,
        material_id: material_id,
        purchase_solicitation_id: purchase_solicitation_id,
        supply_request_id: supply_request_id,
        contract_id: contract_id,
        quantity: quantity
      },
      dataType: 'json',
      type: 'POST',
      success: function (data) {
        $('#supply_request_balance').val(data["balance"]);
        $('#supply_request_unit_value').val(data["value_unit"]);
        $('#supply_request_balance_unit').val(data["balance_unit"]);
        fillTotalAndBalance();
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
      }
    });
  }
}

function fillTotalAndBalance(){
  var quantity = 0;
  var balance_unit = 0;
  var $resquest_quantity = $('#supply_request_quantity'),
      $total_value = $("#supply_request_total_value");

  if(!$resquest_quantity.attr('class').includes("edit")){
    balance_unit = $('#supply_request_balance_unit').val();
    quantity = $('#supply_request_requested_quantity').val();
    $resquest_quantity.val(quantity);
  }

  $total_value.val((quantity * $("#supply_request_unit_value").val()).toFixed(2));

  if(isNaN($total_value.val())){
    $total_value.val(0);
  }
}


function setDisableMaterial(){
  contract_id = $('#supply_request_contract_id').val();
  purchase_solicitation_id = $('#supply_request_purchase_solicitation_id').val();

  if (contract_id!='' && purchase_solicitation_id!='') {
    $("#supply_request_material").attr('disabled', false);
  } else {
    $("#supply_request_material").attr('disabled', true);
  }
}

function setBalanceContract() {
  $("#add-material").click(function () {
    material_id = $("#supply_request_material_id").val();
    contract_id = $("#supply_request_contract_id").val();
    var balance_unit = $('#supply_request_balance_unit').val();

    if (contract_id && material_id) {
      if (Number(balance_unit) < 0 || balance_unit === undefined){
        klass = $('#supply_request_quantity').val(0);
      }

      $.ajax({
        url: Routes.contract + "/" + contract_id + ".json",
        dataType: 'json',
        type: 'GET',
        success: function (data) {
          $("#material-id-" + material_id).children().find("input[type='checkbox']").val(data["balance"]);
          $("#material-id-" + material_id).children().find("input[type='checkbox']").attr('checked', data["balance"]);
        }
      });
    }
  });

  $("input[type='checkbox']").change(function () {
    if ($(this).is(':checked')) {
      $(this).closest("tr").find(".supply_request_items_balance_contract").children().val("true")
    } else {
      $(this).closest("tr").find(".supply_request_items_balance_contract").children().val("false")
    }
  });
}

function setModalUrlToLicitationProcess() {
  var selector_id = '#current_user_department_ids'
  var selector_modal = '#supply_request_licitation_process'

  var id = $(selector_id).val();
  if (id) {
    setModalUrlToLicitationProcessByDepartment(selector_id, selector_modal)
  }
}

$(document).ready(function () {
  setDisableMaterial();
  setModalUrlToContract();
  setModalUrlToCreditor();
  setPledgeSource();
  setModalUrlToPurchaseSolicitation();
  setMaterialTotalAndBalance();
  setModalUrlToMaterial();

  setModalUrlToLicitationProcess();

  $('#supply_request_contract_id').on('change', function (event, contract) {
    setDisableMaterial();
  });

  $('#supply_request_purchase_solicitation_id').on('change', function (event, purchase_solicitation) {
    contract_id = $('#supply_request_contract_id').val();
    purchase_solicitation_id = $('#supply_request_purchase_solicitation_id').val();
    if (purchase_solicitation && contract_id!='' && purchase_solicitation_id!='') {
      $("#supply_request_material").attr('disabled', false);
    } else {
      $("#supply_request_material").attr('disabled', true);
    }
  });

  $('form.supply_request').on('change', '#supply_request_purchase_solicitation_id', function () {
    setDepartment();
    setModalUrlToMaterial();
  });

  $('form.supply_request').on('change', '#supply_request_quantity', function () {
    setMaterialTotalAndBalance();
  });

  $('form.supply_request').on('change', '#supply_request_requested_quantity', function () {

    setMaterialTotalAndBalance();
  });

  $('form.supply_request').on('change', '#supply_request_licitation_process_id', function () {
    if($('#supply_request_licitation_process_id').val() != ''){
      setModalUrlToMaterial();
      $('#supply_request_contract').removeAttr('disabled');
    }else{
      $('#supply_request_contract').attr('disabled','disabled');
    }
  });

  $('form.supply_request').on('change', '#supply_request_material_id', function () {
    $('#supply_request_requested_quantity').val('');
    $('#supply_request_quantity').val('');
    $('#supply_request_balance_unit').val('');
    $('#supply_request_balance').val('');
    $('#supply_request_unit_value').val('');
    $('#supply_request_total_value').val('');
    setMaterialTotalAndBalance();
  });

  $('form.supply_request').on('change', '#supply_request_licitation_process_id', function () {
    setModalUrlToContract();
    setModalUrlToCreditor();
    setPledgeSource();
    setModalUrlToPurchaseSolicitation();
    setMaterialTotalAndBalance();
  });

  $('#supply_request_licitation_process_id').ready(function () {
        var licitation_process_id = $("#supply_request_licitation_process_id").val()

        if (licitation_process_id) {
          $.ajax({
            url: Routes.licitation_processes + "/" + licitation_process_id + ".json",
            dataType: 'json',
            type: 'GET',
            success: function (data) {
              $("#licitation_process_object").val(data["description"])
            }
          });
        }
      }
  )

  $('#supply_request_licitation_process_id').on('change', function (event, licitation_process) {
    if (licitation_process) {
      $("#licitation_process_object").val(licitation_process.description)
      $("#supply_request_modality_or_type_of_removal").val(licitation_process.modality_or_type_of_removal);
      $("#supply_request_purchase_solicitation").attr('disabled', false);
    } else {
      $("#supply_request_modality_or_type_of_removal,#supply_request_purchase_solicitation_id").val('').trigger("change");
      $("#supply_request_creditor_id,#supply_request_creditor").val('').trigger("change");
    }
  });

  $('#supply_request_pledge_id').on('change', function (event, pledge) {
    if (pledge) {
      getPledgeItems(pledge.id);
    }
  });

  if ($("#supply_request_updatabled").prop("checked")) {
    $(".edit-nested-record").attr('class', "edit-nested-record hidden")
    $(".remove-nested-record").attr('class', "remove-nested-record hidden")
  }

  if ($("#supply_request_number_nf").val() == "") {
    $(".supply_request_submit_close").attr('data-disabled', "Desabilitado");
  }

  $("#supply_request_contract_id").on("change", function (event, contract) {
    $("#supply_request_creditor").val(contract ? contract.creditor:'');
    $("#supply_request_creditor_id").val(contract ? contract.creditor_id:'').trigger("change");
  });

  $(".supply_request_submit_close").click(function () {
    $("#supply_request_updatabled").prop('checked', true);
    $("#supply_request_updatabled").val('true');
  });

  $(".supply_request_submit_reopen").click(function () {
    $("#supply_request_updatabled").prop('checked', false);
    $("#supply_request_updatabled").val('false');
  });


  $("#supply_request_number_nf").on("change", function () {
    if ($("#supply_request_number_nf").val() == "") {
      $(".supply_request_submit_close").attr('data-disabled', "Desabilitado");
    } else {
      $(".supply_request_submit_close").removeAttr('data-disabled');
    }
  });

  $(".edit-nested-record").click(function() {
    klass = $('#supply_request_quantity').attr('class');
    $('#supply_request_quantity').attr('class',klass + ' edit');

    $("#supply_request_quantity").attr('disabled', false);
    $("#supply_request_requested_quantity").attr('disabled', true);
  });

  $(".add-nested-record").click(function() {
    klass = $('#supply_request_quantity').attr('class').replace(" edit","");
    $('#supply_request_quantity').attr('class',klass);
    $("#supply_request_quantity").attr('disabled', true);
    $("#supply_request_requested_quantity").attr('disabled', false);
  });

  setBalanceContract();

  $("#gen-suplly-order").click(function(){
    var id = $('#supply_request_id').val(),
        $el = $(this);
    if(confirm("Deseja encerrar este atendimento?")){
    $.ajax({
      url: Routes.supply_request.replace(":id", id),
      data: {supply_request: {updatabled: true }},
      dataType: 'json',
      type: 'PUT',
      success: function (data) {
       generateSupplyOrder($el)
      }
    })
    }else{
      generateSupplyOrder($el)
    }
  });

  function generateSupplyOrder($el){
    var licitation_process = $('#supply_request_licitation_process_id').val(),
      contract = $("#supply_request_contract_id").val(),
      purchase_solicitation = $("#supply_request_purchase_solicitation_id").val(),
      id = $("#supply_request_id").val(),
      items = [],
      input_items='';

    $.each($("#items-records tbody tr.record"), function(){
      items.push([$(this).find('.material-id').val(), $(this).find('.requested_quantity').val()])
    });

    $.each(items, function(index, el){
      input_items += "<input type='hidden' name='supply_order[item]["+ index +"][id]'  value="+el[0]+">";
      input_items += "<input type='hidden' name='supply_order[item]["+ index +"][quantity]'  value="+el[1]+">"
    });

    $("<form action="+ Routes.new_supply_order +" method='GET'/>")
      .append($('<input type="hidden" name="supply_order[licitation_process_id]">').val(licitation_process))
      .append($('<input type="hidden" name="supply_order[contract_id]">').val(contract))
      .append($('<input type="hidden" name="supply_order[purchase_solicitation_id]">').val(purchase_solicitation))
      .append($('<input type="hidden" name="supply_order[supply_request_id]">').val(id))
      .append(input_items)
      .appendTo($(document.body))
      .submit();
  }

  $("#supply_request_department_id").change(function() {
    if($(this).val() === ''){
      $("#supply_request_signature_secretary_id").val('');
      $("#supply_request_signature_secretary").val('');
      return
    }

    $.ajax({
      url: Routes.secretaries,
      data: {by_department: $(this).val()},
      dataType: 'json',
      type: 'GET',
      success: function (data) {
        if(data.length <= 0){
          return alert('Não existe secretaria cadastrada para o Local Solicitante.')
        }
        $('#supply_request_signature_secretary_id').val(data[0].id);
        $('#supply_request_signature_secretary').val(data[0].to_s);
      }
    })
  });
});


