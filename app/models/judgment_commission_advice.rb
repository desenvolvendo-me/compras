class JudgmentCommissionAdvice < Compras::Model
  attr_accessible :licitation_process_id, :licitation_commission_id, :year, :minutes_number
  attr_accessible :judgment_commission_advice_members_attributes
  attr_accessible :judgment_start_date, :judgment_start_time, :judgment_end_date
  attr_accessible :judgment_end_time, :companies_minutes, :companies_documentation_minutes
  attr_accessible :justification_minutes, :judgment_minutes

  belongs_to :licitation_process
  belongs_to :licitation_commission

  has_many :judgment_commission_advice_members, :dependent => :destroy, :order => :id
  has_many :licitation_commission_members, :through => :licitation_commission

  accepts_nested_attributes_for :judgment_commission_advice_members, :allow_destroy => true

  delegate :modality_humanize, :to => :licitation_process, :allow_nil => true, :prefix => true
  delegate :advice_number, :to => :licitation_process, :allow_nil => true, :prefix => true
  delegate :president_name, :to => :licitation_commission, :allow_nil => true, :prefix => true
  delegate :licitation_commission_members, :to => :licitation_commission, :allow_nil => true

  validates :licitation_process, :licitation_commission, :year, :minutes_number, :judgment_sequence, :presence => true
  validates :year, :mask => "9999"
  validates :judgment_start_date, :judgment_start_time, :judgment_end_date, :presence => true
  validates :judgment_end_time, :companies_minutes, :companies_documentation_minutes, :presence => true
  validates :justification_minutes, :judgment_minutes, :presence => true
  validates :judgment_commission_advice_members, :no_duplication => :individual_id

  validate :start_date_time_should_not_be_greater_than_end_date_time

  before_validation :set_minutes_number, :on => :create
  before_validation :set_judgment_sequence, :on => :create

  orderize :id
  filterize

  def to_s
    "#{id}/#{year}"
  end

  def inherited_members
    judgment_commission_advice_members.select(&:inherited?)
  end

  def not_inherited_members
    judgment_commission_advice_members.reject(&:inherited?)
  end

  protected

  def set_judgment_sequence
    self.judgment_sequence = next_judgment_commission_advice_number
  end

  def next_judgment_commission_advice_number
    return unless licitation_process

    licitation_process_advice_number.succ
  end

  def set_minutes_number
    self.minutes_number = next_minutes_number
  end

  def next_minutes_number
    last_minutes_number_of_self_year.succ
  end

  def last_minutes_number_of_self_year
    last_by_self_year.try(:minutes_number).to_i
  end

  def last_by_self_year
    self.class.where { |p| p.year.eq(year) }.order { id }.last
  end

  def judgment_commission_advice_members_not_marked_for_destruction
    judgment_commission_advice_members.reject(&:marked_for_destruction?)
  end

  def start_date_time_should_not_be_greater_than_end_date_time
    return unless judgment_start_date || judgment_start_time ||
                  judgment_end_date || judgment_end_time

    if judgment_start > judgment_end
      errors.add(:judgment_end_date, :start_date_time_should_not_be_greater_than_end_date_time, :restriction => I18n.l(judgment_end, :format => :clean))
    end
  end

  def judgment_start
    DateTime.new(judgment_start_date.year,
                 judgment_start_date.month,
                 judgment_start_date.day,
                 judgment_start_time.hour,
                 judgment_start_time.min)
  end

  def judgment_end
    DateTime.new(judgment_end_date.year,
                 judgment_end_date.month,
                 judgment_end_date.day,
                 judgment_end_time.hour,
                 judgment_end_time.min)
  end
end
