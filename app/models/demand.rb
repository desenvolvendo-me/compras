class Demand < Compras::Model
  attr_accessible :description, :final_date, :initial_date,
    :observation, :status, :year

  has_enumeration_for :status, :with => DemandStatus, :create_helpers => true

  validates :year, presence: true,:mask => '9999',
             numericality: {
                             only_integer: true,
                             greater_than_or_equal_to: 1900,
                             less_than_or_equal_to: Date.today.year+5
                           }

  orderize "created_at"
  filterize

end
