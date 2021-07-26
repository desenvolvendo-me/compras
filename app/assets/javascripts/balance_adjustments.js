//= require modal_filter

function setModalUrlToPurchaseSolicitation() {
    var selector_licitation_process_id = '#balance_adjustment_licitation_process_id'
    var selector_purchase_solicitation_modal = '#balance_adjustment_purchase_solicitation'

    var id = $(selector_licitation_process_id).val();
    if (id) {
        setModalUrlToPurchaseSolicitationByLicitationProcess(selector_licitation_process_id, selector_purchase_solicitation_modal)
    }
}

function setModalUrlToContract() {
    var selector_licitation_process_id = '#balance_adjustment_licitation_process_id'
    var selector_contract_modal = '#balance_adjustment_contract'

    var id = $(selector_licitation_process_id).val();
    if (id) {
        setModalUrlToContractByLicitationProcess(selector_licitation_process_id, selector_contract_modal)
    }
}

function disablePurchaseSolicitation() {
    var licitation_process_id = $("#balance_adjustment_licitation_process_id").val();
    $("#balance_adjustment_purchase_solicitation").attr("disabled", licitation_process_id ? false : true)
}

function disableContract() {
    var purchase_solicitation_id = $("#balance_adjustment_licitation_process_id").val()
    $("#balance_adjustment_contract").attr("disabled", purchase_solicitation_id ? false : true)
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
        lot: item.lot,
        material: item.material.code + " - " + item.material.description,
        quantity: item.quantity,
        quantity_new: 0
    };

    var data = $('#balance_adjustment_items_template').mustache(itemBinds);

    $('#items-records tbody').append(data).trigger("nestedGrid:afterAdd");
}

function loadItem() {
    var purchase_solicitation_id = $("#balance_adjustment_purchase_solicitation_id").val();
    if(purchase_solicitation_id){
        $.ajax({
            url: Routes.purchase_solicitations_api_show,
            data: {purchase_solicitation_id: purchase_solicitation_id},
            dataType: 'json',
            type: 'POST',
            success: function (data) {
                $.each(data.items, function (i, item) {
                    if (hasItemAlreadyAdded(item)) {
                        // mergeItem(item);
                    } else {
                        renderItem(item);
                    }
                });
            }
        });
    }
}

$(document).ready(function () {
    disablePurchaseSolicitation();
    setModalUrlToPurchaseSolicitation();
    disableContract();
    setModalUrlToContractByLicitationProcess();
    loadItem();

    $('#balance_adjustment_licitation_process_id').on('change', function () {
        disablePurchaseSolicitation();
        setModalUrlToPurchaseSolicitation();
        disableContract();
        setModalUrlToContract();
    });


    $("#balance_adjustment_purchase_solicitation_id").on("change", function () {
        loadItem();
    });
});
