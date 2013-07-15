class BudgetAllocationsController < ApiConsumerController
  private

  def fetch_params
    super.merge(includes: :expense_nature)
  end
end
