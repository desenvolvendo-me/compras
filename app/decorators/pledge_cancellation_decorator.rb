class PledgeCancellationDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  def emission_date
    localize super if super
  end

  def expiration_date
    localize super if super
  end

  def balance
    number_with_precision super if super
  end

  def pledge_balance
    number_to_currency super if super
  end

  def pledge_value
    number_to_currency super if super
  end

  def pledge_cancellations_sum
    number_to_currency super if super
  end

  def pledge_liquidations_sum
    number_to_currency super if super
  end
end
