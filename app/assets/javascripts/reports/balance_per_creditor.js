//= require modal_filter

function setModalUrlToLicitationProcess() {
    var selector_id = '#balance_per_creditor_report_creditor_id'
    var selector_modal = '#balance_per_creditor_report_licitation_process'

    var id = $(selector_id).val();
    if (id) {
        setModalUrlToLicitationProcessByCreditor(selector_id, selector_modal)
    }
}

function setModalUrlToDepartment() {
    var selector_id = '#balance_per_creditor_report_creditor_id'
    var selector_modal = '#balance_per_creditor_report_department'

    var id = $(selector_id).val();
    if (id) {
        setModalUrlToDepartmentByCreditor(selector_id, selector_modal)
    }
}

function disableLicitationProcess() {
    var creditor_id = $("#balance_per_creditor_report_creditor_id").val()
    $("#balance_per_creditor_report_licitation_process").attr("disabled", creditor_id ? false : true)
}

function disableDepartment() {
    var purchase_process_id = $("#balance_per_creditor_report_creditor_id").val()
    $("#balance_per_creditor_report_department").attr("disabled", purchase_process_id ? false : true)
}

$(document).ready(function () {
    disableLicitationProcess();
    disableDepartment();

    setModalUrlToLicitationProcess();
    setModalUrlToDepartment();
    $('#balance_per_creditor_report_creditor_id').on('change', function () {
        disableLicitationProcess();
        disableDepartment();

        setModalUrlToLicitationProcess();
        setModalUrlToDepartment();
    });


});
