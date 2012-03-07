module Dashboard::AdministractiveProcessHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.bid_openings
    end
  end
end
