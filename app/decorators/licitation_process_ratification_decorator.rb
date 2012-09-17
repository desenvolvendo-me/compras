# encoding: utf-8
class LicitationProcessRatificationDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  def ratification_date
    localize super if super
  end

  def adjudication_date
    localize super if super
  end

  def proposals_total_value
    number_with_precision super if super
  end

  def budget_allocations
    component.bidder_proposals.map { |p| p.budget_allocation }.uniq.join(', ')
  end
end
