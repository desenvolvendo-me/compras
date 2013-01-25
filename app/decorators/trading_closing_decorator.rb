class TradingClosingDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::TranslationHelper

  attr_header :created_at_date, :status, :observation

  def created_at_date
    I18n.l created_at.to_date
  end
end
