class BudgetRevenueDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::TranslationHelper

  def date(date_repository = ::Date)
    if component.persisted?
      created_at_or_default = created_at.to_date
    else
      created_at_or_default = date_repository.current
    end

    localize created_at_or_default
  end
end
