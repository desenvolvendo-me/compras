class PriceRegistration < Compras::Model
  attr_accessible :date, :delivery, :delivery_unit, :description,
                  :observations, :situation, :validaty_date, :validaty_unit,
                  :validity, :year, :licitation_process_id, :payment_method_id,
                  :delivery_location_id, :management_unit_id, :responsible_id,
                  :items_attributes

  attr_readonly :number

  attr_modal :number, :year, :description

  has_enumeration_for :delivery_unit, :with => PeriodUnit
  has_enumeration_for :situation, :with => PriceRegistrationSituation
  has_enumeration_for :validaty_unit, :with => PeriodUnit

  belongs_to :delivery_location
  belongs_to :licitation_process
  belongs_to :management_unit
  belongs_to :payment_method
  belongs_to :responsible, :class_name => 'Employee'

  has_many :items, :class_name => 'PriceRegistrationItem', :dependent => :destroy, :inverse_of => :price_registration

  has_one :direct_purchase, :dependent => :restrict

  accepts_nested_attributes_for :items, :allow_destroy => true

  validates :licitation_process, :year, :presence => true
  validates :date, :validaty_date, :timeliness => { :type => :date },
    :allow_blank => true
  validates :year, :mask => '9999', :allow_blank => true

  auto_increment :number, :by => :year

  orderize :id
  filterize

  def to_s
    "#{number}/#{year}"
  end
end
