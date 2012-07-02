class RevenueNatureDecorator < Decorator
  def publication_date
    helpers.l super if super
  end
end
