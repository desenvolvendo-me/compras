function setModalUrlToPurchaseSolicitationByLicitationProcess(selector_licitation_process_id, selector_purchase_solicitation_modal) {
    var urlModal = Routes.modal_purchase_solicitations,
        params = {
            by_licitation_process: $(selector_licitation_process_id).val()
        };

    urlModal += "?" + $.param(params);
    console.log(urlModal)
    console.log(selector_licitation_process_id)
    console.log(selector_purchase_solicitation_modal)
    $(selector_purchase_solicitation_modal).data('modal-url', urlModal);
}