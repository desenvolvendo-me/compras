module Dashboard::EconomicHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.risk_degrees
    end
  end
end
