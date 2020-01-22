function setModalUrlToCreditor() {
    var urlModal = Routes.modal_creditors,
        params = {
            by_ratification_and_licitation_process_id: $('#additive_solicitation_licitation_process_id').val()
        };

    urlModal += "?" + $.param(params);
    $('#additive_solicitation_creditor').data('modal-url', urlModal);
}

function setModalUrlToDepartment() {
    var urlModal = Routes.modal_departments,
        params = {
            by_purchasing_unit_for_licitation_process: $('#additive_solicitation_licitation_process_id').val()
        };

    urlModal += "?" + $.param(params);
    $('#additive_solicitation_department').data('modal-url', urlModal);
}

function setModalUrlToMaterial() {
    var urlSource = Routes.materials,
        params = {
            by_licitation_process: $('#additive_solicitation_licitation_process_id').val()
        };

    urlSource += "?" + $.param(params);

    $('#additive_solicitation_material').attr('data-source', urlSource);
}

function enableAfterlicitationProcessId() {
    var licitation_process_id = $('#additive_solicitation_licitation_process_id').val()

    if (licitation_process_id) {
        $("#additive_solicitation_creditor").attr("disabled", false);
        $("#additive_solicitation_department").attr("disabled", false);
        $("#additive_solicitation_material").attr("disabled", false);
        $("#additive_solicitation_quantity").attr("disabled", false);
        $("#additive_solicitation_value").attr("disabled", false);
    } else {
        $("#additive_solicitation_creditor").attr("disabled", true);
        $("#additive_solicitation_department").attr("disabled", true);
        $("#additive_solicitation_material").attr("disabled", true);
        $("#additive_solicitation_quantity").attr("disabled", true);
        $("#additive_solicitation_value").attr("disabled", true);
    }

}

function setMaterialMarginBalance() {
    var material_id = $('#additive_solicitation_material_id').val()
    var licitation_process_id = $('#additive_solicitation_licitation_process_id').val()
    var quantity = $('#additive_solicitation_quantity').val()
    var value = $('#additive_solicitation_value').val()

    if (licitation_process_id && material_id && quantity && value) {
        $.ajax({
            url: Routes.additive_solicitation_material_margin,
            data: {
                material_id: material_id,
                licitation_process_id: licitation_process_id,
                quantity: quantity,
                value: value,
            },
            dataType: 'json',
            type: 'POST',
            success: function (data) {
                $('#additive_solicitation_balance').val(data["balance"] + "%");
            }
        });
    }
}

$(document).ready(function () {
    setModalUrlToCreditor();
    setModalUrlToDepartment();
    setModalUrlToMaterial();
    setMaterialMarginBalance();
    enableAfterlicitationProcessId();

    $('form.additive_solicitation').on('change', '#additive_solicitation_licitation_process_id, #additive_solicitation_material_id, #additive_solicitation_quantity, #additive_solicitation_value', function () {
        setMaterialMarginBalance();
    });

    $('form.additive_solicitation').on('change', '#additive_solicitation_licitation_process_id', function () {
        setModalUrlToCreditor();
        setModalUrlToDepartment();
        enableAfterlicitationProcessId();
        setModalUrlToMaterial();
    });

});
