class BudgetRevenueDecorator < Decorator
  def date(date_repository = ::Date)
    if component.persisted?
      created_at_or_default = original_component.created_at.to_date
    else
      created_at_or_default = date_repository.current
    end

    helpers.l created_at_or_default
  end
end
