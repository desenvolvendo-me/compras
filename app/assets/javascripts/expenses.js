function setModalUrlToOrganOrUnity(id, type) {
    var urlModal = Routes.modal_organs,
        params = {
            by_organ_type: type
        };

    urlModal += "?" + $.param(params);
    $(id).data('modal-url', urlModal);
}


$(document).ready(function () {
    setModalUrlToOrganOrUnity("#expense_organ", "organ");
    setModalUrlToOrganOrUnity("#expense_unity", "unity");
});
