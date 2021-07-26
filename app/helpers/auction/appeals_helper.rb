module Auction::AppealsHelper
  def new_title
    I18n.t("#{controller_name}.new", :resource => singular, :cascade => true) + ' - Pregão ' + resource.auction.to_s
  end

  def edit_title
    I18n.t("#{controller_name}.edit", :resource => singular, :cascade => true) + ' - Pregão ' + resource.auction.to_s
  end

  def has_opening_and_closure?
    resource.opening_date && resource.opening_time && resource.closure_date && resource.closure_time
  end
end