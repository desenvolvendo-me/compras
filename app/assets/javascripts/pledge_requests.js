//= require modal_filter

function setCreditor() {
    var contract_id = $('#pledge_request_contract_id').val()
    if (contract_id) {
        $.ajax({
            url: Routes.contracts_plegde_request,
            data: {
                contract_id: contract_id
            },
            dataType: 'json',
            type: 'POST',
            success: function (data) {
                $('#pledge_request_creditor_show').val(data["creditor"]);
                $('#pledge_request_balance_show').val("R$ " + data["balance"]);
                $('#pledge_request_value_show').val("R$ " + data["value"]);
            }
        });
    }
}

function setModalUrlToLicitationProcess() {
    var selector_id = '#pledge_request_contract_id'
    var selector_modal = '#pledge_request_purchase_process'

    var id = $(selector_id).val();
    if (id) {
        setModalUrlToLicitationProcessByContract(selector_id, selector_modal)
    }
}

function setModalUrlToPurchaseSolicitation() {
    var selector_licitation_process_id = '#pledge_request_purchase_process_id'
    var selector_purchase_solicitation_modal = '#pledge_request_purchase_solicitation'

    var id = $(selector_licitation_process_id).val();
    if (id) {
        setModalUrlToPurchaseSolicitationByLicitationProcess(selector_licitation_process_id, selector_purchase_solicitation_modal)
    }
}

function setModalUrlToPurchaseForm() {
    var selector_purchase_solicitation_id = '#pledge_request_purchase_solicitation_id'
    var selector_purchase_form_modal = '#pledge_request_purchase_form'

    var id = $(selector_purchase_solicitation_id).val();
    if (id) {
        setModalUrlToPurchaseFormByPurchaseSolicitation(selector_purchase_solicitation_id, selector_purchase_form_modal)
    }
}

function disableLicitationProcess() {
    var purchase_contract_id = $("#pledge_request_contract_id").val()
    $("#pledge_request_purchase_process").attr("disabled", purchase_contract_id ? false : true)
}

function disablePurchaseSolicitation() {
    var purchase_process_id = $("#pledge_request_purchase_process_id").val()
    $("#pledge_request_purchase_solicitation").attr("disabled", purchase_process_id ? false : true)
}

function disablePurchaseForm() {
    var purchase_solicitation_id = $("#pledge_request_purchase_solicitation_id").val()
    $("#pledge_request_purchase_form").attr("disabled", purchase_solicitation_id ? false : true)
}

$(document).ready(function () {
    setCreditor();
    disableLicitationProcess();
    setModalUrlToLicitationProcess();
    disablePurchaseSolicitation();
    setModalUrlToPurchaseSolicitation();
    disablePurchaseForm();
    setModalUrlToPurchaseForm();

    $('#pledge_request_contract_id').on('change', function () {
        setCreditor();
        disableLicitationProcess();
        setModalUrlToLicitationProcess();
    });

    $('#pledge_request_purchase_process_id').on('change', function () {
        disablePurchaseSolicitation();
        setModalUrlToPurchaseSolicitation();
    });

    $('#pledge_request_purchase_solicitation_id').on('change', function () {
        disablePurchaseForm();
        setModalUrlToPurchaseForm();
    });

});
