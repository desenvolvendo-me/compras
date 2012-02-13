module Dashboard::EconomicHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.risk_degrees
      m.cnaes
      m.branch_classifications
    end
  end
end
