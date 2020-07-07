class AuctionDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::TranslationHelper

  attr_header :licitation_number, :year, :object

  def number_year
    "#{licitation_number}/#{year}"
  end

end
