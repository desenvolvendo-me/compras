class BidderDisqualificationDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::TranslationHelper

  def created_at
    l(super.to_date) if super
  end
end
