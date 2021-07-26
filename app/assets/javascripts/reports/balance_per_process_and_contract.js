//= require modal_filter


function setModalUrlToContract() {
    var selector_id = '#balance_per_process_and_contract_report_licitation_process_id'
    var selector_modal = '#balance_per_process_and_contract_report_contract'

    var id = $(selector_id).val();
    if (id) {
        setModalUrlToContractByLicitationProcess(selector_id, selector_modal)
    }
}

function disableContract() {
    var licitation_process_id = $("#balance_per_process_and_contract_report_licitation_process_id").val()
    $("#balance_per_process_and_contract_report_contract").attr("disabled", licitation_process_id ? false : true)
}

function setModalUrlToCreditorPC() {
    var selector_id = '#balance_per_process_and_contract_report_contract_id'
    var selector_modal = '#balance_per_process_and_contract_report_creditor'

    var id = $(selector_id).val();
    if (id) {
        setModalUrlToCreditorByContract(selector_id, selector_modal)
    }
}

function disableCreditor() {
    var contract_id = $("#balance_per_process_and_contract_report_contract_id").val()
    $("#balance_per_process_and_contract_report_creditor").attr("disabled", contract_id ? false : true)
}


$(document).ready(function () {
    disableContract();
    disableCreditor();

    setModalUrlToContract();
    setModalUrlToCreditorPC();

    $('#balance_per_process_and_contract_report_licitation_process_id').on('change', function () {
        disableContract();

        setModalUrlToContract();
    });

    $('#balance_per_process_and_contract_report_contract_id').on('change', function () {
        disableCreditor();

        setModalUrlToCreditorPC();
    });


});
