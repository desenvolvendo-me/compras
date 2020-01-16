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
        setModalUrlToContractByPurchaseSolicitation(selector_licitation_process_id, selector_contract_modal)
    }
}

function disablePurchaseSolicitation() {
    var licitation_process_id = $("#balance_adjustment_licitation_process_id").val();
    console.log(licitation_process_id);
    $("#balance_adjustment_purchase_solicitation").attr("disabled", licitation_process_id ? false : true)
}

function disableContract() {
    var purchase_solicitation_id = $("#balance_adjustment_licitation_process_id").val()
    $("#balance_adjustment_contract").attr("disabled", purchase_solicitation_id ? false : true)
}

$(document).ready(function () {
    disablePurchaseSolicitation();
    setModalUrlToPurchaseSolicitation();
    disableContract();
    setModalUrlToContractByPurchaseSolicitation();

    $('#balance_adjustment_licitation_process_id').on('change', function () {
        disablePurchaseSolicitation();
        setModalUrlToPurchaseSolicitation();
        disableContract();
        setModalUrlToContract();
    });

});
