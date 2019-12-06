class Demand < Compras::Model
  attr_accessible  :name,:final_date, :initial_date,
    :observation, :status, :year,:purchasing_unit_id,
                   :purchase_solicitation_id,
                   :department_ids

  belongs_to :purchase_solicitation
  belongs_to :purchasing_unit
  has_many :demand_batches, class_name: 'DemandBatch', :order => :id,dependent: :destroy

  has_many :demand_departments, :dependent => :destroy
  has_many :departments, :through => :demand_departments, :order => :id


  has_enumeration_for :status, :with => DemandStatus, :create_helpers => true

  validates :year,:name, presence: true
  validates :year,:mask => '9999',
             numericality: {
                             only_integer: true,
                             greater_than_or_equal_to: 1900,
                             less_than_or_equal_to: Date.today.year+5
                           }

  orderize "created_at"
  filterize

  def to_s
    "#{name}"
  end

end
