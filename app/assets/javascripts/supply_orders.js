//= require modal_filter
//= require input

function setModalUrlToPurchaseSolicitation() {

    var selector_modal = '#supply_order_purchase_solicitation';
    var lic_pro = $('#supply_order_licitation_process_id').val();

    params = {
        by_department_user_access_and_licitation_process: lic_pro+","+$('#current_user_id').val()
    };

    setModalUrl(selector_modal,'purchase_solicitations',params);
}

function setModalUrlToPurchaseForm() {
    var urlModal = Routes.modal_purchase_forms,
        params = {
            by_purchase_solicitation: $('#supply_order_purchase_solicitation_id').val()
        };

    urlModal += "?" + $.param(params);
    $('#supply_order_purchase_form').data('modal-url', urlModal);
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

    $.getIndex(pledgeItemsUrl, params, function (pledge_items) {
        fillSupplyOrderQuantities(pledge_items);
    });
}

function fillSupplyOrderQuantities(pledge_items) {
    var target = $('div#supply_order_items'),
        templateValue = $('#supply_order_items_value_template'),
        templateQuantity = $('#supply_order_items_quantity_template');

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
    var purchase_solicitation_id = $('#supply_order_purchase_solicitation_id').val()

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

function setBilling(){
  var purchase_solicitation_id = $('#supply_order_purchase_solicitation_id').val()

  if (purchase_solicitation_id) {
    $.ajax({
      url: Routes.purchasing_units,
      data: {by_purchase_solicitation: purchase_solicitation_id},
      dataType: 'json',
      type: 'GET',
      success: function (data) {
        $('#supply_order_observation').val(data[0]["billing"]);
      },
      error: function (XMLHttpRequest, textStatus, errorThrown){
        console.log(textStatus)
      }
    });
  }
}

function setMaterialTotalAndBalance(quantity, material, $scope) {
    var licitation_process_id = $('#supply_order_licitation_process_id').val();
    var purchase_solicitation_id = $('#supply_order_purchase_solicitation_id').val();
    var contract_id = $('#supply_order_contract_id').val();
    var supply_order_id = $(window.location.href.split("/")).get(-2);

    if (licitation_process_id && purchase_solicitation_id && contract_id && supply_order_id && material && quantity) {
        $.ajax({
            url: Routes.licitation_process_material_total_balance,
            data: {
                licitation_process_id: licitation_process_id,
                material_id: material,
                purchase_solicitation_id: purchase_solicitation_id,
                supply_order_id: supply_order_id,
                contract_id: contract_id,
                quantity: quantity
            },
            dataType: 'json',
            type: 'POST',
            success: function (data) {
              if(data['balance'] < 0){
                custom_alert( 'Saldo de material insuficiente!', 'Atenção');
                $scope.find('.supply_order_quantity').val(0);
              }else{
                $scope.find('.supply_order_balance').val(data["balance"]);
              }
            }
        });
    }
}

function hasItemAlreadyAdded(item) {
    var added = false;
    $("table#items-records input.material-id").each(function () {
        if ($(this).val() == item.material_id) {
            added = true;
            return added;
        }
    });
    return added;
}

function mergeItem(item) {
    var record = $('tr#material-id-' + item.material_id);
    var quantity = record.find('input.quantity').val();
    var totalQuantity = parsePtBrFloat(quantity) + item.quantity;

    record.find("td.quantity").text(totalQuantity);
    record.find('input.quantity').val(totalQuantity);
}

function renderItem(item) {
    var itemBinds = {
        uuid: _.uniqueId('fresh-'),
        id: '',
        material_id: item.material_id,
        material: item.material.code + " - " + item.material.description,
        quantity: item.quantity,
        lot: item.lot
    };

    var data = $('#supply_order_items_template').mustache(itemBinds);
    $('#items-records tbody').append(data).trigger("nestedGrid:afterAdd");
}

function setModalUrlToSupplyRequest() {
    var selector_modal = '#supply_order_supply_request';

    params = {
        by_purchase_solicitation: $('#supply_order_purchase_solicitation_id').val(),
        by_creditor: $('#supply_order_creditor_id').val()
    };

    setModalUrl(selector_modal,'supply_requests',params);
}
function setModalUrlToLiciationProccess() {
    var selector_modal = '#supply_order_licitation_process';
    params = {
        by_status: "approved",
        by_purchasing_unit: $('#current_user_id').val()
    };

    setModalUrl(selector_modal,'licitation_processes',params);
}

function setModalUrlToContract() {
    var urlModal = Routes.modal_contracts,
        params = {
            purchase_process_id: $('#supply_order_licitation_process_id').val()
        };

    urlModal += "?" + $.param(params);
    $('#supply_order_contract').data('modal-url', urlModal);
}

function setModalUrlToMaterial() {
    var urlSource = Routes.materials,
        params = {
            by_licitation_process: $('#supply_order_licitation_process_id').val()
        };

    urlSource += "?" + $.param(params);

    $('#supply_order_material').attr('data-source', urlSource);
}

$(document).ready(function () {
    setModalUrlToSupplyRequest();
    setModalUrlToLiciationProccess();
    setModalUrlToPurchaseForm();
    setModalUrlToCreditor();
    setPledgeSource();
    setModalUrlToPurchaseSolicitation();
    setMaterialTotalAndBalance();
    setModalUrlToContract();
    setModalUrlToMaterial();
    disableWhenSelected("#supply_order_licitation_process_id", "#supply_order_contract");
    disableWhenSelected("#supply_order_licitation_process_id", "#supply_order_purchase_solicitation");
    update_total_value();

    $('form.supply_order').on('change', '#supply_order_purchase_solicitation_id', function () {
      setBilling();
      setDepartment();
        setModalUrlToPurchaseForm();
    });

    $('form.supply_order').on('change', '.supply_order_quantity', function () {
        var quantity = $(this).val(),
            $scope = $(this).closest("tr"),
            material = $scope.data('material');

        setMaterialTotalAndBalance(quantity, material, $scope);
    });


    $('form.supply_order').on('change', '#supply_order_licitation_process_id', function () {
        setModalUrlToCreditor();
        setPledgeSource();
        setModalUrlToPurchaseSolicitation();
        setMaterialTotalAndBalance();
        setModalUrlToContract();
        setModalUrlToMaterial();
    });

    $('#supply_order_licitation_process').on('change', function (event, licitation_process) {
        if (licitation_process) {
            $("#supply_order_licitation_process_description").val(licitation_process.description);
            $("#supply_order_modality_or_type_of_removal").val(licitation_process.modality_or_type_of_removal);
            $("#supply_order_purchase_solicitation").attr('disabled', false);
        } else {
            $("#supply_order_modality_or_type_of_removal, #supply_order_creditor,#supply_order_purchase_solicitation_id").val('');
        }
    });

    $('#supply_order_pledge_id').on('change', function (event, pledge) {
        if (pledge) {
            getPledgeItems(pledge.id);
        }
    });

    if ($("#supply_order_updatabled").prop("checked")) {
        $(".edit-nested-record").attr('class', "edit-nested-record hidden")
        $(".remove-nested-record").attr('class', "remove-nested-record hidden")
    }

    $(".supply_order_submit_close").attr('data-disabled', "Desabilitado");

    $("#supply_order_contract_id").on("change", function (event, contract) {
        $("#supply_order_creditor").val(contract ? contract.creditor : '');
    });

    $(".supply_order_submit_close").click(function () {
        $("#supply_order_updatabled").prop('checked', true);
    });

    $("#supply_order_invoices_adicionar").on("click", function () {
        if (!$('#supply_order_updatabled').is(':checked')) {
            $(".supply_order_submit_close").removeAttr('data-disabled');
        }
    });

    $("#supply_order_requests_adicionar").on("click", function () {
        setTimeout(function () {
            var supply_request_ids = []

            $("table#supply_order_requests-records input.supply_request-id").each(function () {
                supply_request_ids.push($(this).val())
            });

            $.ajax({
                url: Routes.supply_requests_api_show,
                data: {supply_request_ids: supply_request_ids},
                dataType: 'json',
                type: 'POST',
                success: function (data) {
                    $.each(data, function (i, supply_request) {
                        $.each(supply_request.items, function (i, item) {
                            if (hasItemAlreadyAdded(item)) {
                                mergeItem(item);
                            } else {
                                renderItem(item);
                            }
                        });
                    });

                }
            });
        }, 1000);


    });

  $("#supply_order_contract_id").change(function () {
    var contract_id = $(this).val();

    var $input_complete = $(".supply_order_expense .ui-autocomplete-input");

    $input_complete.attr('data-source', '/expenses?by_contract='+contract_id);
  });

  $("#supply_order_expense_id").change(function(){
    var expense_id  = $(this).val(),
        contract_id = $("#supply_order_contract_id").val();

    var $input_complete = $(".supply_order_secretary .auto_complete");

    $input_complete.attr('data-source', Routes.secretaries+'?by_contract_expense%5Bcontract%5D='+contract_id+'&by_contract_expense%5Bexpanse%5D='+expense_id);
  });


  /** tab Nota Fiscal **/
  supply_order_id = $(window.location.href.split("/")).get(-2);
  $number = $("#supply_order_number");
  $date_invoice = $("#supply_order_date");
  $release_date = $("#supply_order_release_date");

  $("#supply_order_invoices_adicionar").click(function(){
    $(".supply_order_date p").remove();
    $(".supply_order_release_date p").remove();
  });


  $("#invoices-records").on('nestedGrid:afterAdd', function(){
    var $last_tr = $("#invoices-records").find("tbody tr").last();

    var i = $last_tr.data('index');

    $("#invoice-items-records tbody>tr").each(function( index ){
      var inputs = '';

      $(this).find(':input').each(function(){
        var name = $(this).attr('name'),
          matches = name.match(/\[(\w+)\]$/),
          value = $(this).val();
        inputs += "<input  name='supply_order[invoices_attributes]["+i+"][supply_order_item_invoices_attributes]["+index+"]["+matches[1]+"]' value='"+value+"' type='hidden'>"
      });

      $last_tr.find('.supply_order_item_invoices').append("<div class='append-item-"+index+"'></div>");
      $last_tr.find('.supply_order_item_invoices .append-item-'+index).append(inputs);
    });
  });


  $(document).on('click', '.nested-record .edit-nested-invoice', function(event) {
    event.preventDefault();

    editNestedGridRecord( $(this).closest('.nested-record') );
  });

  function editNestedGridRecord(row) {
    var nestedFields = row.closest('table.records').siblings('.nested-fields:visible'),
      name, matches, input, material, $tr;

    row.find(':input').not(".item-invoice").each(function() {
      matches = $(this).attr('name').match(/\[(\w+)\]$/);

      if (matches) {
        name = matches[1];
        input = nestedFields.find(':input[name*="[' + name + ']"]').not('#invoice_items_id');

        if ( input.is(':checkbox') ) {
          if ( $(this).val() == 'true' || $(this).val() == '1' ) {
            input.attr('checked', true);
          } else {
            input.attr('checked', false);
          }
        } else {
          input.val( $(this).val() );
        }
      }
    });

    row.find('.supply_order_item_invoices :input').each(function(){
      matches = $(this).attr('name').match(/\[(\w+)\]$/);

      if (matches) {
        name = matches[1];
        material = $(this).closest('.item-invoice-record').data('material');
        $tr = nestedFields.find("#invoice-items-records tr[data-material="+material+"]");
        input = $tr.find(':input[name*="[' + name + ']"]');

        input.val( $(this).val() );
      }
      setBalanceOnEdit($tr);

    });

    row.remove();
  }

  function setBalanceOnEdit($tr){
    $tr.find('.balance').data('balance', $tr.find('.quantity_supplied').val());
    $tr.find('.quantity_supplied').trigger('keyup');

    if(parseInt($tr.find('.quantity_supplied').val()) > 0){
      $tr.show();
    }
  }

  function update_total_value(){
    var total = 0.0;
    $("#invoice-items-records tbody>tr .balance").each(function( index ){
      total += parsePtBrFloat($(this).find(':input').val());
    });

    $("#total-invoice-value").val(floatToPtBrString(total))
  }

  $(".quantity_supplied").on('keyup',function(){

    var $tr = $(this).closest('tr'),
      unit_price = parseFloat($tr.find('.balance').data('price')),
      qtd_balance = parseInt($tr.find('.balance').data('balance')),
      quantity = parseInt($(this).val());

    if($.isNumeric( quantity)){
      if( qtd_balance - quantity >= 0){
        $tr.find('.balance :input').val(floatToPtBrString(unit_price * quantity));
        update_total_value()
      }else{
        custom_alert( 'Você não pode solicitar um valor maior do que o saldo disponível.', 'Atenção' );
        $(this).val(0);
      }
    }
  });

  $("#invoices-records").on('nestedGrid:afterAdd', function(e){
    $('form.supply_order').submit();
  });

  $("#competence_month_select").change(function(){
    $("#invoice_competence_month").val($(this).val())
  });

  function setCompetenceMonth(){
    var date = $("#invoice_competence_month").val();
    $("#competence_month_select option[value='"+date+"']").prop('selected', 'selected');
  }

  $("#invoice_competence_month").change(function () {
    setCompetenceMonth();
  });

  $(".remove-invoice").click(function(){
    var $el = $(this);
    var btn = {"Apagar": function() {
        $el.closest('td').find('.remove-nested-record').click();
        $( this ).dialog( "close" );
      },
      Cancelar: function() {
        $( this ).dialog( "close" );
      }};
    custom_alert("Você tem certeza que deseja apagar o registro?", "Remover Registro", btn)
  });

  setCompetenceMonth();
  /** tab Nota Fiscal **/


  $(function(){
    $(".tabs").tabs({
      active: sessionStorage.getItem("currentTabIndexSupplyOrder"),
      activate: function(event, ui) {
        var tabIndex = $(".tabs").tabs('option', 'active');
        sessionStorage.setItem("currentTabIndexSupplyOrder", tabIndex);
      }
    });
  });

  $('#invoices-records').on('nestedGrid:afterRemove', function(){
    $('form.supply_order').submit();
  });

});
