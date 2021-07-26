function setModalUrl(selector_modal,controller,params) {
    var urlModal = Routes['modal_'+controller], params ;
    $(selector_modal).data('modal-url', urlModal += "?" + $.param(params) );
}

function setModalUrlToCreditorByContract(selector_id, selector_modal) {
    var value = $(selector_id).val();
    var urlModal = Routes.modal_creditors,
        params = {
            by_contract: value
        };

    urlModal += "?" + $.param(params);
    $(selector_modal).data('modal-url', urlModal);
}

function setModalUrlToCreditorByPurchasingUnit(selector_id, selector_modal) {
    var value = $(selector_id).val();
    var urlModal = Routes.modal_creditors,
        params = {
            by_purchasing_unit: value
        };

    urlModal += "?" + $.param(params);

    $(selector_modal).data('modal-url', urlModal);
}

function setModalUrlToCreditorByLicitationProcess(selector_id, selector_modal) {
    var value = $(selector_id).val();
    var urlModal = Routes.modal_creditors,
        params = {
            by_ratification_and_licitation_process_id: value
        };

    urlModal += "?" + $.param(params);
    $(selector_modal).data('modal-url', urlModal);
}

function setModalUrlToPurchaseSolicitationByLicitationProcess(selector_id, selector_modal) {
    var value = $(selector_id).val();
    var urlModal = Routes.modal_purchase_solicitations,
        params = {
            by_licitation_process: value
        };

    urlModal += "?" + $.param(params);
    $(selector_modal).data('modal-url', urlModal);
}

function setModalUrlToMaterialByLicitationProcess(selector_id, selector_modal) {
    var value = $(selector_id).val();
    var urlModal = Routes.modal_materials,
        params = {
            by_licitation_process: value
        };

    urlModal += "?" + $.param(params);not_persisted_message
    $(selector_modal).data('modal-url', urlModal);
}

function setSourceToMaterialByLicitationProcess(selector_id, selector_modal) {
    var value = $(selector_id).val();
    var urlModal = Routes.materials,
        params = {
            by_licitation_process: value
        };

    urlModal += "?" + $.param(params);
    $(selector_modal).data('source', urlModal);
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

function setModalUrlToLicitationProcessByCreditor(selector_id, selector_modal) {
    var value = $(selector_id).val();
    var urlModal = Routes.modal_licitation_processes,
        params = {
            by_creditor: value
        };

    urlModal += "?" + $.param(params);
    $(selector_modal).data('modal-url', urlModal);
}

function setModalUrlToDepartmentByCreditor(selector_id, selector_modal) {
    var value = $(selector_id).val();
    var urlModal = Routes.modal_departments,
        params = {
            by_creditor: value
        };

    urlModal += "?" + $.param(params);
    $(selector_modal).data('modal-url', urlModal);
}

function setModalUrlToLicitationProcessByDepartment(selector_id, selector_modal) {
    var value = $(selector_id).val();
    var urlModal = Routes.modal_licitation_processes,
        params = {
            by_department: value
        };

    urlModal += "?" + $.param(params);
    $(selector_modal).data('modal-url', urlModal);
}

function setModalUrlToContractByLicitationProcess(selector_id, selector_modal) {
    var value = $(selector_id).val();
    var urlModal = Routes.modal_contracts,
        params = {
            purchase_process_id: value
        };

    urlModal += "?" + $.param(params);
    $(selector_modal).data('modal-url', urlModal);
}
