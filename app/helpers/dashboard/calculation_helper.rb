module Dashboard::CalculationHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.working_hours
      m.currencies
    end
  end
end
