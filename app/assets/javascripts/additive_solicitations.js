function setModalUrlToPurchaseSolicitation() {
    var urlModal = Routes.modal_purchase_solicitations,
        params = {
            by_licitation_process: $('#additive_solicitation_licitation_process_id').val()
        };

    urlModal += "?" + $.param(params);
    $('#additive_solicitation_purchase_solicitation').data('modal-url', urlModal);
}

function setModalUrlToCreditor() {
    var urlModal = Routes.modal_creditors,
        params = {
            by_ratification_and_licitation_process_id: $('#additive_solicitation_licitation_process_id').val()
        };

    urlModal += "?" + $.param(params);
    $('#additive_solicitation_creditor').data('modal-url', urlModal);
}

function setPledgeSource() {
    var url = Routes.pledges,
        params = {
            by_purchase_process_id: $('#additive_solicitation_licitation_process_id').val()
        };

    url += "?" + $.param(params);
    $('#additive_solicitation_pledge').data('source', url);
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
    var target = $('div#additive_solicitation_items'),
        templateValue = $('#additive_solicitation_items_value_template'),
        templateQuantity = $('#additive_solicitation_items_quantity_template');

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
    var purchase_solicitation_id = $('#additive_solicitation_purchase_solicitation_id').val()

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
    var licitation_process_id = $('#additive_solicitation_licitation_process_id').val()
    var material_id = $('#additive_solicitation_material_id').val()
    var purchase_solicitation_id = $('#additive_solicitation_purchase_solicitation_id').val()
    var contract_id = $('#additive_solicitation_contract_id').val()
    var additive_solicitation_id = $(window.location.href.split("/")).get(-2)
    var quantity = $('#additive_solicitation_quantity').val()

    if (licitation_process_id && purchase_solicitation_id && material_id && quantity) {
        $.ajax({
            url: Routes.licitation_process_material_total_balance,
            data: {
                licitation_process_id: licitation_process_id,
                material_id: material_id,
                purchase_solicitation_id: purchase_solicitation_id,
                additive_solicitation_id: additive_solicitation_id,
                contract_id: contract_id,
                quantity: quantity
            },
            dataType: 'json',
            type: 'POST',
            success: function (data) {
                $('#additive_solicitation_balance').val(data["balance"]);
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
        quantity: item.quantity

    };

    var data = $('#licitation_process_items_template').mustache(itemBinds);

    $('#items-records tbody').append(data).trigger("nestedGrid:afterAdd");
}


$(document).ready(function () {
    setModalUrlToCreditor();
    setPledgeSource();
    setModalUrlToPurchaseSolicitation();
    setMaterialTotalAndBalance();

    $('form.additive_solicitation').on('change', '#additive_solicitation_purchase_solicitation_id', function () {
        setDepartment();
    });

    $('form.additive_solicitation').on('change', '#additive_solicitation_quantity', function () {
        setMaterialTotalAndBalance();
    });

    $('form.additive_solicitation').on('change', '#additive_solicitation_material_id', function () {
        setMaterialTotalAndBalance();
    });

    $('form.additive_solicitation').on('change', '#additive_solicitation_licitation_process_id', function () {
        setModalUrlToCreditor();
        setPledgeSource();
        setModalUrlToPurchaseSolicitation();
        setMaterialTotalAndBalance();
    });

    $('#additive_solicitation_licitation_process').on('change', function (event, licitation_process) {
        if (licitation_process) {
            $("#additive_solicitation_modality_or_type_of_removal").val(licitation_process.modality_or_type_of_removal);
            $("#additive_solicitation_purchase_solicitation").attr('disabled', false);
        } else {
            $("#additive_solicitation_modality_or_type_of_removal, #additive_solicitation_creditor,#additive_solicitation_purchase_solicitation_id").val('');
        }
    });

    $('#additive_solicitation_pledge_id').on('change', function (event, pledge) {
        if (pledge) {
            getPledgeItems(pledge.id);
        }
    });

    if ($("#additive_solicitation_updatabled").prop("checked")) {
        $(".edit-nested-record").attr('class', "edit-nested-record hidden")
        $(".remove-nested-record").attr('class', "remove-nested-record hidden")
    }

    if ($("#additive_solicitation_number_nf").val() == "") {
        $(".additive_solicitation_submit_close").attr('data-disabled', "Desabilitado");
    }

    $("#additive_solicitation_contract_id").on("change", function (event, contract) {
        $("#additive_solicitation_creditor").val(contract ? contract.creditor : '');
    });

    $(".additive_solicitation_submit_close").click(function () {
        $("#additive_solicitation_updatabled").prop('checked', true);
    });

    $("#additive_solicitation_number_nf").on("change", function () {
        if ($("#additive_solicitation_number_nf").val() == "") {
            $(".additive_solicitation_submit_close").attr('data-disabled', "Desabilitado");
        } else {
            $(".additive_solicitation_submit_close").removeAttr('data-disabled');
        }
    });

    $("#additive_solicitation_supply_request_id").on("change", function (event, supplyRequest) {

        $.ajax({
            url: Routes.supply_requests_api_show,
            data: {supply_request_id: supplyRequest.id},
            dataType: 'json',
            type: 'POST',
            success: function (data) {
                console.log(data)
                $.each(data.items, function (i, item) {
                    if (hasItemAlreadyAdded(item)) {
                        mergeItem(item);
                    } else {
                        renderItem(item);
                    }
                });
            }
        });

    });

});
