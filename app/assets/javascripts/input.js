function disableWhenSelected(select_id, select_input) {
    var object_id = $(select_id).val()
    $(select_input).attr("disabled", object_id ? false : true)
    $('form').on('change', select_id, function () {
        var object_id = $(select_id).val()
        $(select_input).attr("disabled", object_id ? false : true)
    });
}
