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
      by_deparment_permited: $('#current_user').val()
    };
    setModalUrl(selector_modal,'purchase_solicitations',params);
}

function setModalUrlToMaterial() {
    var selector_id = '#supply_request_licitation_process_id'
    var selector_modal = '#supply_request_material'
    setSourceToMaterialByLicitationProcess(selector_id, selector_modal)
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
    var licitation_process_id = $('#supply_request_licitation_process_id').val()
    var material_id = $('#supply_request_material_id').val()
    var purchase_solicitation_id = $('#supply_request_purchase_solicitation_id').val()
    var contract_id = $('#supply_request_contract_id').val()
    var supply_request_id = $(window.location.href.split("/")).get(-2)
    var quantity = $('#supply_request_quantity').val()

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
            }
        });
    }
}

$(document).ready(function () {
    setModalUrlToContract();
    setModalUrlToCreditor();
    setPledgeSource();
    setModalUrlToPurchaseSolicitation();
    setMaterialTotalAndBalance();

    disableWhenSelected("#supply_request_purchase_solicitation_id", "#supply_request_material")

    $('form.supply_request').on('change', '#supply_request_purchase_solicitation_id', function () {
        setDepartment();
        setModalUrlToMaterial();
    });

    $('form.supply_request').on('change', '#supply_request_quantity', function () {
        setMaterialTotalAndBalance();
    });

    $('form.supply_request').on('change', '#supply_request_licitation_process_id', function () {
        if($('#supply_request_licitation_process_id').val() != ''){
            $('#supply_request_contract').removeAttr('disabled');
        }else{
            $('#supply_request_contract').attr('disabled','disabled');
        }
    });

    $('form.supply_request').on('change', '#supply_request_material_id', function () {
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
            $("#supply_request_modality_or_type_of_removal, #supply_request_creditor,#supply_request_purchase_solicitation_id").val('');
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
        $("#supply_request_creditor_id").val(contract ? contract.id:'');
    });

    $(".supply_request_submit_close").click(function () {
        $("#supply_request_updatabled").prop('checked', true);
    });

    $("#supply_request_number_nf").on("change", function () {
        if ($("#supply_request_number_nf").val() == "") {
            $(".supply_request_submit_close").attr('data-disabled', "Desabilitado");
        } else {
            $(".supply_request_submit_close").removeAttr('data-disabled');
        }
    });
});
