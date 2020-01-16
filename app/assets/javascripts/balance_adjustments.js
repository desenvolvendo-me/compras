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
    console.log(item.material)
    var itemBinds = {
        uuid: _.uniqueId('fresh-'),
        id: '',
        material_id: item.material_id,
        material: item.material_description,
        quantity: item.quantity,
        quantity_new: 0
    };

    var data = $('#balance_adjustment_items_template').mustache(itemBinds);

    $('#items-records tbody').append(data).trigger("nestedGrid:afterAdd");
}

$(document).ready(function () {
    disablePurchaseSolicitation();
    setModalUrlToPurchaseSolicitation();
    disableContract();
    setModalUrlToContractByLicitationProcess();

    $('#balance_adjustment_licitation_process_id').on('change', function () {
        disablePurchaseSolicitation();
        setModalUrlToPurchaseSolicitation();
        disableContract();
        setModalUrlToContract();
    });


    $("#balance_adjustment_purchase_solicitation_id").on("change", function (event, purchaseSolicitation) {

        if (!purchaseSolicitation) {
            purchaseSolicitation = {};
        }
        console.log(purchaseSolicitation)
        $.each(purchaseSolicitation.items, function (i, item) {
            if (hasItemAlreadyAdded(item)) {
                mergeItem(item);
            } else {
                renderItem(item);
            }
        });

    });
});
