$(document).ready(function() {
  // function hasAlreadyAddedBudgetAllocation(budgetAllocation) {
  //   var nestedBudgetAllocationGridRows = $("#purchase_process_budget_allocations_records tr.record").not('.removed'),
  //       gotBudgetAllocation = false;
  //
  //   nestedBudgetAllocationGridRows.each(function(index, obj) {
  //     var budgetRow = $(obj).find(".licitation_process_purchase_process_budget_allocations_budget_allocation_id :input");
  //
  //     if (budgetRow.val() == budgetAllocation.budget_allocation_id) {
  //       gotBudgetAllocation = true;
  //       return false;
  //     }
  //   });
  //
  //   return gotBudgetAllocation;
  // }
  //
  // function renderBudgetAllocation(budgetAllocation) {
  //   var nestedBudgetAllocationGridTemplate = $("#purchase_process_budget_allocations_template"),
  //       budgetAllocationBinds = {
  //         uuid: _.uniqueId('fresh-'),
  //         id: '',
  //         budget_allocation: budgetAllocation.budget_allocation,
  //         budget_allocation_id: budgetAllocation.budget_allocation_id,
  //         budget_allocation_expense_nature: budgetAllocation.budget_allocation_expense_nature,
  //         expense_nature: budgetAllocation.expense_nature,
  //         expense_nature_id: budgetAllocation.expense_nature_id,
  //         budget_allocation_balance: budgetAllocation.balance,
  //         value: numberWithDelimiter(budgetAllocation.estimated_value)
  //       };
  //
  //   if ( !hasAlreadyAddedBudgetAllocation(budgetAllocation) ) {
  //     $("#purchase_process_budget_allocations_records tbody").append(nestedBudgetAllocationGridTemplate.mustache(budgetAllocationBinds));
  //     $("#purchase_process_budget_allocations_records").trigger('nestedGrid:afterAdd');
  //   }
  // }
  //
  // function sumPurchaseProcessBudgetAllocationTotalValue() {
  //   var totalValue = 0,
  //       tableRows  = $('#purchase_process_budget_allocations_records tr.record').not('.removed');
  //
  //   tableRows.find('.licitation_process_purchase_process_budget_allocations_value :input').each(function() {
  //     totalValue += parsePtBrFloat( $(this).val() );
  //   });
  //
  //   $('#licitation_process_budget_allocations_total_value').val( numberWithDelimiter(totalValue) );
  // }
  //
  // function sumItemTotalValue() {
  //   var total = 0,
  //   item_total_value_fields = $('#items-records .nested-record').not('.removed')
  //                                                               .find('input.item-total-value');
  //
  //   item_total_value_fields.each(function() {
  //     total += parsePtBrFloat( $(this).val() );
  //   });
  //
  //   return total;
  // }
  //
  // $('#items-nested').on('nestedGrid:afterRemove', function () {
  //   sumItemTotalValue();
  // });
  //
  // $('#budget_allocation_tab_header').click(function() {
  //   $('#licitation_process_total_value_of_items').val( numberWithDelimiter(sumItemTotalValue()) );
  // });
  //
  // $("#licitation_process_purchase_solicitations_id").on("change", function(event, purchaseSolicitation) {
  //   if (purchaseSolicitation) {
  //     $.each(purchaseSolicitation.budget_allocations, function(i, budgetAllocation) {
  //       renderBudgetAllocation(budgetAllocation);
  //     });
  //   }
  // });
  //
  // $('#licitation_process_budget_allocation_id').on('change', function(event, budgetAllocation) {
  //   var url    = Routes.expense_natures,
  //       year   = $('#licitation_process_year').val(),
  //       params = { by_parent_id: budgetAllocation.expense_nature_id, by_year: year };
  //
  //   $('#licitation_process_budget_allocation_balance').val(budgetAllocation.balance);
  //   $('#licitation_process_budget_allocation_expense_nature').val(budgetAllocation.expense_nature);
  //   $('#budget_allocation_expense_nature_id').val(budgetAllocation.expense_nature_id);
  //
  //   url += "?" + jQuery.param(params);
  //
  //   $("#licitation_process_expense_nature").data('source', url);
  // });
  //
  // $('#purchase_process_budget_allocations_records').on('nestedGrid:afterAdd', function() {
  //   sumPurchaseProcessBudgetAllocationTotalValue();
  // });
  //
  // $('#purchase_process_budget_allocations_records').on('nestedGrid:afterRemove', function() {
  //   sumPurchaseProcessBudgetAllocationTotalValue();
  // });
  //
  // if ( $("#licitation_process_purchase_solicitation_id").val() ) {
  //   // Disable budget_allocations
  //   $("#budget_allocations :input").attr("readonly", "readonly");
  //   $("#budget_allocations .modal").attr("disabled", "disabled");
  //   $("#budget_allocations .auto_complete").attr("disabled", "disabled")
  //                                          .addClass("disabled_auto_complete")
  //                                          .removeClass("auto_complete");
  //   $("#budget_allocations .remove-administrative-process-budget-allocation").hide();
  //   $("#budget_allocations .add-administrative-process-budget-allocation").hide();
  // }
});
