class RevenueNatureDecorator < Decorator
  attr_data 'docket' => :docket

  def publication_date
    helpers.l component.publication_date if component.publication_date
  end
end
