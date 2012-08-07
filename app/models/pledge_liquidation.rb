class PledgeLiquidation < Compras::Model
  attr_accessible :pledge_id, :value, :date, :description,
                  :pledge_liquidation_parcels_attributes

  attr_accessor :parcel_replicated_value

  attr_modal :pledge_id, :value, :date

  has_enumeration_for :status, :with => PledgeLiquidationStatus, :create_helpers => true, :create_scopes => true

  belongs_to :pledge

  has_one :annul, :class_name => 'ResourceAnnul', :as => :annullable, :dependent => :destroy

  has_many :pledge_liquidation_parcels, :dependent => :destroy, :order => :number

  accepts_nested_attributes_for :pledge_liquidation_parcels, :allow_destroy => true

  delegate :emission_date, :pledge_liquidations_sum,
           :pledge_cancellations_sum, :to => :pledge, :allow_nil => true
  delegate :value, :balance, :to => :pledge, :prefix => true, :allow_nil => true

  validates :pledge, :date, :presence => true
  validates :value, :presence => true, :numericality => { :greater_than => 0 }
  validate :date_must_be_greater_than_emission_date
  validate :validate_value
  validate :parcels_sum_must_be_equals_to_value

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :date, :timeliness => {
      :on_or_after => lambda { last.date },
      :on_or_after_message => :must_be_greater_or_equal_to_last_pledge_liquidation_date,
      :type => :date,
      :on => :create,
      :if => :any_pledge_liquidation?
    }
  end

  orderize :id
  filterize

  def self.total_value_by_activated
    active.sum(:value)
  end

  def annul!
    update_column :status, PledgeLiquidationStatus::ANNULLED
  end

  def to_s
    id.to_s
  end

  def parcels_sum
    pledge_liquidation_parcels.map(&:value).compact.sum
  end

  protected

  def parcels_sum_must_be_equals_to_value
    return unless value

    if parcels_sum != value
      errors.add(:parcels_sum, :must_be_equals_to_value, :value => decorator.value)
    end
  end

  def any_pledge_liquidation?
    self.class.any?
  end

  def date_must_be_greater_than_emission_date
    return unless pledge && date

    if date < emission_date
      errors.add(:date, :must_be_greater_than_pledge_emission_date, :restriction => I18n.l(emission_date))
    end
  end

  def validate_value(numeric_parser = ::I18n::Alchemy::NumericParser)
    return unless pledge && value

    if value > pledge_balance
      errors.add(:value, :must_not_be_greater_than_pledge_balance, :value => numeric_parser.localize(pledge_balance))
    end
  end
end
