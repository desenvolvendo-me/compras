class TradingClosingDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::TranslationHelper

  def created_at_date
    I18n.l created_at.to_date
  end
end
