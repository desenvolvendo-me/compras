module Auction::SuspensionsHelper
  def new_title
    I18n.t("#{controller_name}.new", :resource => singular, :cascade => true) + ' - ' + resource.auction.to_s
  end

  def edit_title
    I18n.t("#{controller_name}.edit", :resource => singular, :cascade => true)+ ' - ' + resource.auction.to_s
  end
end