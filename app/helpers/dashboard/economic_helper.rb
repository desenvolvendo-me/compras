module Dashboard::EconomicHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.risk_degrees
      m.cnaes
      m.branch_activities
      m.branch_classifications
      m.issqn_classifications
    end
  end
end
