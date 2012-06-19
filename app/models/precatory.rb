class Precatory < Compras::Model
  attr_accessible :number, :creditor_id, :historic, :precatory_type_id
  attr_accessible :date, :judgment_date, :apresentation_date, :lawsuit_number
  attr_accessible :value, :precatory_parcels_attributes

  belongs_to :creditor
  belongs_to :precatory_type

  has_many :precatory_parcels, :dependent => :destroy, :order => :id

  accepts_nested_attributes_for :precatory_parcels, :allow_destroy => true

  validates :number, :creditor, :historic, :precatory_type, :presence => true
  validates :date, :judgment_date, :apresentation_date, :presence=> true
  validates :value, :presence => true
  validate :must_parceled_value_be_equal_value

  orderize :id
  filterize

  def parceled_value
    precatory_parcels.map(&:value).compact.sum
  end

  def to_s
    number
  end

  private

  def must_parceled_value_be_equal_value
    if parceled_value != value
      errors.add(:parceled_value, :must_be_equal_precatory_value)
    end
  end
end
