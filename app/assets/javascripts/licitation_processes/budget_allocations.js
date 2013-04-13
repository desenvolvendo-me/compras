$(document).ready(function() {
  function hasAlreadyAddedBudgetAllocation(budgetAllocation) {
    var nestedBudgetAllocationGridRows = $("#administrative-process-budget-allocation-records tr.record").not('[style*="display: none"]'),
        gotBudgetAllocation = false;

    nestedBudgetAllocationGridRows.each(function(index, obj) {
      var budgetRow = $(obj).find("input.budget_allocation_id");

      if (budgetRow.val() == budgetAllocation.budget_allocation_id) {
        gotBudgetAllocation = true;
        return false;
      }
    });

    return gotBudgetAllocation;
  }

  function renderBudgetAllocation(budgetAllocation) {
    var nestedBudgetAllocationGridTemplate = $("#administrative_process_budget_allocations_template"),
        budgetAllocationBinds = {
          uuid: _.uniqueId('fresh-'),
          budget_allocation: budgetAllocation.budget_allocation,
          budget_allocation_id: budgetAllocation.budget_allocation_id,
          budget_allocation_expense_nature: budgetAllocation.budget_allocation_expense_nature,
          expense_nature: budgetAllocation.expense_nature,
          expense_nature_id: budgetAllocation.expense_nature_id,
          budget_allocation_amount: numberWithDelimiter(budgetAllocation.amount),
          administrative_process_budget_allocation_value: numberWithDelimiter(budgetAllocation.estimated_value)
        };

    if ( !hasAlreadyAddedBudgetAllocation(budgetAllocation) ) {
      $("#administrative-process-budget-allocation-records tbody").append(nestedBudgetAllocationGridTemplate.mustache(budgetAllocationBinds));
      $("#administrative-process-budget-allocation-records").trigger('nestedGrid:afterAdd');
    }
  }

  function sumAdministrativeProcessBudgetAllocationTotalValue() {
    var totalValue = 0,
        tableRows  = $('#administrative-process-budget-allocation-records tr.record').not('.removed');

    tableRows.find('input.administrative_process_budget_allocation_value').each(function() {
      totalValue += parsePtBrFloat( $(this).val() );
    });

    $('#licitation_process_budget_allocations_total_value').val( numberWithDelimiter(totalValue) );
  }

  function sumItemTotalValue() {
    var total = 0,
    item_total_value_fields = $('#items-records .nested-record').not('.removed')
                                                                .find('input.item-total-value');

    item_total_value_fields.each(function() {
      total += parsePtBrFloat( $(this).val() );
    });

    return total;
  }

  $('#items-nested').on('nestedGrid:afterRemove', function () {
    sumItemTotalValue();
  });

  $('#budget_allocation_tab_header').click(function() {
    $('#licitation_process_total_value_of_items').val( numberWithDelimiter(sumItemTotalValue()) );
  });

  $("#licitation_process_purchase_solicitations_id").on("change", function(event, purchaseSolicitation) {
    if (purchaseSolicitation) {
      $.each(purchaseSolicitation.budget_allocations, function(i, budgetAllocation) {
        renderBudgetAllocation(budgetAllocation);
      });
    }
  });

  $('#licitation_process_budget_allocation_id').on('change', function(event, budgetAllocation) {
    var url    = Routes.expense_natures,
        params = { breakdown_of: budgetAllocation.expense_nature_id };

    $('#licitation_process_budget_allocation_amount').val(numberWithDelimiter(parseFloat(budgetAllocation.amount)));
    $('#licitation_process_budget_allocation_expense_nature').val(budgetAllocation.expense_nature);
    $('#budget_allocation_expense_nature_id').val(budgetAllocation.expense_nature_id);

    url += "?" + jQuery.param(params);

    $("#licitation_process_expense_nature").data('source', url);
  });

  $('#administrative-process-budget-allocation-records').on('nestedGrid:afterAdd', function() {
    sumAdministrativeProcessBudgetAllocationTotalValue();
  });

  $('#administrative-process-budget-allocation-records').on('nestedGrid:afterRemove', function() {
    sumAdministrativeProcessBudgetAllocationTotalValue();
  });

  if ( $("#licitation_process_purchase_solicitation_id").val() ) {
    // Disable budget_allocations
    $("#budget_allocations :input").attr("readonly", "readonly");
    $("#budget_allocations .modal").attr("disabled", "disabled");
    $("#budget_allocations .auto_complete").attr("disabled", "disabled")
                                           .addClass("disabled_auto_complete")
                                           .removeClass("auto_complete");
    $("#budget_allocations .remove-administrative-process-budget-allocation").hide();
    $("#budget_allocations .add-administrative-process-budget-allocation").hide();
  }
});
