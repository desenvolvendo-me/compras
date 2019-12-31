module NumberSupply
  extend ActiveSupport::Concern

  included do
    before_create :set_number

    validates :year, presence: true

    def set_number
      number = 0
      so = SupplyOrder.maximum(:number, conditions: ["compras_supply_orders.year = #{self.year}"])
      if so.present?
        number = so
      end
      self.number = "#{(number.to_i + 1)}/#{self.year}"
    end
  end
end