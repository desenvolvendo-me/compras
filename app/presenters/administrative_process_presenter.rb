# encoding: utf-8
class AdministrativeProcessPresenter < Presenter::Proxy
  def value_estimated
    helpers.number_to_currency(object.value_estimated)
  end

  def total_allocations_value
    helpers.number_with_precision(object.total_allocations_value)
  end
end
