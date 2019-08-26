class Demand < Compras::Model
  attr_accessible :description, :final_date, :initial_date,
    :observation, :status, :year, :name,:demand_batches_attributes

  has_many :demand_batches, class_name: 'DemandBatch', :order => :id,dependent: :destroy
  accepts_nested_attributes_for :demand_batches, allow_destroy: true

  has_enumeration_for :status, :with => DemandStatus, :create_helpers => true

  validates :status, presence: true
  validates :year, presence: true,:mask => '9999',
             numericality: {
                             only_integer: true,
                             greater_than_or_equal_to: 1900,
                             less_than_or_equal_to: Date.today.year+5
                           }

  orderize "created_at"
  filterize

end
