class RecordPrice < Compras::Model
  attr_accessible :date, :delivery, :delivery_unit, :description, :number,
                  :observations, :situation, :validaty_date, :validaty_unit,
                  :validity, :year, :licitation_process_id,
                  :delivery_location_id, :management_unit_id, :responsible_id,
                  :payment_method_id

  has_enumeration_for :delivery_unit, :with => PeriodUnit
  has_enumeration_for :situation, :with => RecordPriceSituation
  has_enumeration_for :validaty_unit, :with => PeriodUnit

  belongs_to :delivery_location
  belongs_to :licitation_process
  belongs_to :management_unit
  belongs_to :payment_method
  belongs_to :responsible, :class_name => 'Employee'

  validates :licitation_process, :presence => true
  validates :date, :validaty_date, :timeliness => { :type => :date },
    :allow_blank => true

  orderize :id
  filterize

  scope :by_year_and_less_than_me, lambda { |year, id|
    where { |record| record.year.eq(year) & record.id.lteq(id) }
  }

  def to_s
    "#{year}/#{count_by_year_and_less_than_me}"
  end

  protected

  def count_by_year_and_less_than_me
    RecordPrice.by_year_and_less_than_me(year, id).count
  end
end
