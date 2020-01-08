function setMaterialMarginBalance() {
    var material_id = $('#additive_solicitation_material_id').val()
    var licitation_process_id = $('#additive_solicitation_licitation_process_id').val()

    if (material_id) {
        $.ajax({
            url: Routes.additive_solicitation_material_margin,
            data: {
                material_id: material_id,
                licitation_process_id: licitation_process_id,
            },
            dataType: 'json',
            type: 'POST',
            success: function (data) {
                $('#additive_solicitation_balance').val(data["balance"]);
                $('#additive_solicitation_value').val(data["value"]);
            }
        });
    }
}

$(document).ready(function () {
    setMaterialMarginBalance();

    $('form.additive_solicitation').on('change', '#additive_solicitation_material_id', function () {
        setMaterialMarginBalance();
    });

});
