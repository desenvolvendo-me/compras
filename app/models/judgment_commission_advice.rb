class JudgmentCommissionAdvice < Compras::Model
  attr_accessible :licitation_process_id, :licitation_commission_id, :year, :minutes_number
  attr_accessible :judgment_commission_advice_members_attributes
  attr_accessible :judgment_start_date, :judgment_start_time, :judgment_end_date
  attr_accessible :judgment_end_time, :companies_minutes, :companies_documentation_minutes
  attr_accessible :justification_minutes, :judgment_minutes, :issuance_date

  belongs_to :licitation_process
  belongs_to :licitation_commission

  has_many :judgment_commission_advice_members, :dependent => :destroy, :order => :id
  has_many :licitation_commission_members, :through => :licitation_commission

  accepts_nested_attributes_for :judgment_commission_advice_members, :allow_destroy => true

  delegate :modality_humanize, :licitation?, :simplified_processes?, :to => :licitation_process, :allow_nil => true, :prefix => true
  delegate :president_name, :to => :licitation_commission, :allow_nil => true, :prefix => true
  delegate :licitation_commission_members, :to => :licitation_commission, :allow_nil => true

  validates :licitation_process, :presence => true
  validates :year, :mask => "9999"
  validates :judgment_commission_advice_members, :no_duplication => :individual_id

  validate :start_date_time_should_not_be_greater_than_end_date_time

  before_validation :set_minutes_number, :on => :create

  orderize "id DESC"
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

  def got_start_and_end_dates?
    (judgment_start_date && judgment_start_time && judgment_end_date && judgment_end_time)
  end

  def start_date_time_should_not_be_greater_than_end_date_time
    return unless got_start_and_end_dates?

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
