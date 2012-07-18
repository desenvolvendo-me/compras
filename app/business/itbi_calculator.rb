class ItbiCalculator
  attr_accessor :property_transfer_object, :setting_repository, :property_object

  def initialize(property_transfer_object, setting_repository = Setting)
    self.property_transfer_object = property_transfer_object
    self.property_object = property_transfer_object.property
    self.setting_repository = setting_repository
  end

  def call
    calculate_amount_tax + calculate_amount_financed_tax
  end

  private

  def amount
    (amount_property > declared_amount ? amount_property : declared_amount) - amount_financed
  end

  def amount_property
    property_object.market_value + property_object.terrain_market_value
  end

  def declared_amount
    property_transfer_object.declared_value_of_transaction
  end

  def amount_financed
    property_transfer_object.amount_financed
  end

  def calculate_amount_tax
    (amount * setting_repository.fetch(:rate_property_transfer).to_f) / 100
  end

  def calculate_amount_financed_tax
    (amount_financed * setting_repository.fetch(:rate_property_transfer_funded).to_f) / 100
  end
end
