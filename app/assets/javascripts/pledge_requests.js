function sumTotalItems() {
    var unit_price, quantity, total = 0;

    $('.nested-items:visible').each(function () {
        unit_price = new BigNumber(parsePtBrFloat($(this).find('.unit_price').val() || '0'));
        quantity = new BigNumber($(this).find('.quantity').val() || '0');

        total += unit_price * quantity;
    });

    $('#pledge_request_items_total_value').val(numberWithDelimiter(total));
}

function setItemModalUrl() {
    var url = Routes.modal_purchase_processe_items,
        creditor_id = $('#pledge_request_creditor_id').val(),
        purchase_process_id = $('#pledge_request_purchase_process_id').val(),
        params = {
            ratification_creditor_id: creditor_id,
            licitation_process_id: purchase_process_id
        };

    url += '?' + $.param(params);

    $('input.purchase_process_item').data('modal-url', url);
}

function setCreditorModalUrl() {
    var url = Routes.modal_creditors,
        purchase_process_id = $('#pledge_request_purchase_process_id').val(),
        params = {
            by_ratification_and_licitation_process_id: purchase_process_id
        };

    url += '?' + $.param(params);

    $('#pledge_request_creditor').data('modal-url', url);
}

function setContractModalUrl() {
    var url = Routes.modal_contracts,
        purchase_process_id = $('#pledge_request_purchase_process_id').val(),
        params = {
            purchase_process_id: purchase_process_id
        };

    url += '?' + $.param(params);

    $('#pledge_request_contract').data('modal-url', url);
}

function setBudgetAllocationSource(budget_allocations_ids) {
    var url = Routes.budget_allocations,
        params = {
            by_ids: budget_allocations_ids
        };

    url += '?' + $.param(params);

    $('#pledge_request_budget_allocation').data('source', url);
}

function setExpenseNatureModalUrl(parent_id) {
    var url = Routes.modal_expense_natures,
        params = {
            by_parent_id: parent_id
        };

    url += '?' + $.param(params);

    $('#pledge_request_expense_nature').data('modal-url', url);
}

function setReserveFunds() {
    var url = Routes.reserve_funds,
        params = {
            by_purchase_process_id: $('#pledge_request_purchase_process_id').val(),
            without_pledge: true
        },
        request = $.ajax({
            url: url,
            data: params,
            dataType: 'json',
        });

    request.done(function (data) {
        $('#pledge_request_reserve_fund_id').html('');

        _(data).each(function (reserve_fund) {
            $('#pledge_request_reserve_fund_id').append(function () {
                return $('<option>').text(reserve_fund.label)
                    .val(reserve_fund.id)
                    .data('amount', reserve_fund.amount);
            });
        });

        $('#pledge_request_reserve_fund_id').trigger('change');
    });

    request.fail(function (jqXHR, textStatus, errorThrown) {
        $('#pledge_request_reserve_fund_id').html('');
    });
}

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
                $('#pledge_request_balance_show').val(data["balance"]);
                $('#pledge_request_value_show').val(data["value"]);
            }
        });
    }
}

function setPurchaseSolicitationBalance() {
    var purchase_process_id = $('#pledge_request_purchase_process_id').val()
    var purchase_solicitation_id = $('#pledge_request_purchase_solicitation_id').val()

    if (purchase_solicitation_id) {
        $.ajax({
            url: Routes.purchase_solicitation_balance,
            data: {
                purchase_solicitation_id: purchase_solicitation_id,
                purchase_process_id: purchase_process_id
            },
            dataType: 'json',
            type: 'GET',
            success: function (data) {
                $('#pledge_request_purchase_solicitation_balance').val(data["balance"]);

            }
        });
    }
}

$(document).ready(function () {
    setCreditor();
    setPurchaseSolicitationBalance();

    $('#pledge_request_purchase_solicitation_id').on('change', function () {
        setPurchaseSolicitationBalance();
    });

    $('#pledge_request_contract_id').on('change', function () {
        setCreditor();
    });

    $('form#new_pledge_request').on('keyup', '.quantity', function () {
        sumTotalItems();
    });

    $('form#new_pledge_request').on('click', '.remove-items', function () {
        sumTotalItems();
    });

    $('#pledge_request_purchase_process_id').on('change', function (event, purchase_process) {
        if (!purchase_process) {
            purchase_process = {};
        }

        setCreditorModalUrl();
        setContractModalUrl();
        setItemModalUrl();

        setBudgetAllocationSource(purchase_process.budget_allocations_ids);
        // setReserveFunds();
    });

    $('#pledge_request_creditor_id').on('change', function () {
        setItemModalUrl();
    });

    $('#pledge_request_reserve_fund_id').on('change', function () {
        var option = $(this).find('option:selected');

        // $('#pledge_request_reserve_fund_amount').val(option.data('amount'));
    });

    $('#pledge_request_budget_allocation_id').on('change', function (event, budget_allocation) {
        if (!budget_allocation) {
            budget_allocation = {};
        }

        $('#pledge_request_budget_allocation_balance').val(budget_allocation.balance);
        $('#pledge_request_descriptor_id').val(budget_allocation.descriptor_id);

        setExpenseNatureModalUrl(budget_allocation.expense_nature_id);
    });

    $('#items').on('nestedForm:afterAdd', function () {
        setItemModalUrl();
    });

    $(document).on('change', 'input:hidden[name*="purchase_process_item_id"]', function (event, item) {
        var $item_wrapper = $(this).closest('.nested-items');

        if (!item) {
            item = {};
        }

        $item_wrapper.find('.additional_information')
            .val(item.additional_information);

        $item_wrapper.find('.item_number')
            .val(item.item_number);

        $item_wrapper.find('.lot')
            .val(item.lot);

        $item_wrapper.find('.unit_price')
            .val(item.ratification_item_unit_price);
    });
});
