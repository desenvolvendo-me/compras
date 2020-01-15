function setModalUrlToPurchaseSolicitationByLicitationProcess(selector_id, selector_modal) {
    var value = $(selector_id).val();
    var urlModal = Routes.modal_purchase_solicitations,
        params = {
            by_licitation_process: value
        };

    urlModal += "?" + $.param(params);
    $(selector_modal).data('modal-url', urlModal);
}

function setModalUrlToPurchaseFormByPurchaseSolicitation(selector_id, selector_modal) {
    var value = $(selector_id).val();
    var urlModal = Routes.modal_purchase_forms,
        params = {
            by_purchase_solicitation: value
        };

    urlModal += "?" + $.param(params);
    $(selector_modal).data('modal-url', urlModal);
}

function setModalUrlToLicitationProcessByContract(selector_id, selector_modal) {
    var value = $(selector_id).val();
    var urlModal = Routes.modal_licitation_processes,
        params = {
            by_contract: value
        };

    urlModal += "?" + $.param(params);
    $(selector_modal).data('modal-url', urlModal);
}

