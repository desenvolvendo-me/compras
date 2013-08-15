class RegulatoryAct < Unico::RegulatoryAct
  attr_modal :act_number, :regulatory_act_type

  has_enumeration_for :classification, :with => RegulatoryActClassification, :create_helpers => { :prefix => true }
  has_enumeration_for :budget_change_decree_type, :create_helpers => { :prefix => true }
  has_enumeration_for :origin
  has_enumeration_for :budget_change_law_type
  has_enumeration_for :regulatory_act_type, :create_helpers => { :prefix => true }

  has_and_belongs_to_many :dissemination_sources, join_table: :unico_dissemination_sources_unico_regulatory_acts

  delegate :classification_law?, :regulatory_act_type_budget_change?, :regulatory_act_type_loa?, :to => :parent, :prefix => true, :allow_nil => true

  validates :regulatory_act_type, :creation_date, :publication_date, :content,
            :signature_date, :vigor_date, :act_number,
            :classification, :presence => true
  validates :authorized_value, :presence => true, :if => :is_law_and_loa_or_budget_change_or_decree_and_parent_is_loa_or_budget_change?
  validates :additional_percent, :presence => true, :if => :is_law_and_loa_or_budget_change?
  validates :additional_percent, :numericality => { :greater_than => 0, :less_than_or_equal_to => 100 },
            :if => :is_law_and_loa_or_budget_change?
  validates :article_number, :length => { :maximum => 6 }, :allow_blank => true
  validates :article_description, :length => { :maximum => 512 }, :allow_blank => true
  validates :budget_change_decree_type, :presence => true, :if => :budget_change_decree_type_required?
  validates :budget_change_law_type, :presence => true, :if => :budget_change_law_type_required?

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :act_number, :content, :uniqueness => true
    allowing_blank.validates :act_number, :numericality => true
    allowing_blank.validates :vigor_date,
      :timeliness => {
        :on_or_after => :creation_date,
        :on_or_after_message => :should_be_on_or_after_creation_date,
        :type => :date
      }
    allowing_blank.validates :publication_date,
      :timeliness => {
        :on_or_after => :creation_date,
        :on_or_after_message => :should_be_on_or_after_creation_date,
        :type => :date
       }
    allowing_blank.validates :publication_date,
      :timeliness => {
        :on_or_before => :vigor_date,
        :on_or_before_message => :should_be_on_or_before_vigor_date,
        :type => :date
      }
  end

  scope :created_at_before, lambda {
    |year, month, day| where {
      creation_date.lte(Date.new(year.to_i, month.to_i, day.to_i))
    }
  }

  scope :trading_or_price_registration, lambda {
    where {
      regulatory_act_type.in([RegulatoryActType::REGULAMENTATION_OF_PRICE_REGISTRATION,
                              RegulatoryActType::REGULAMENTATION_OF_TRADING])
    }
  }

  before_save :clear_budget_change_decree_type_unless_required,
              :clear_authorized_value_unless_required,
              :clear_additional_percent_unless_required,
              :clear_origin_unless_updateable,
              :clear_budget_change_law_type_unless_required

  orderize :act_number
  filterize

  def self.by_creation_date(date_range)
    where { creation_date.in(date_range) }
  end

  def self.by_creation_month(date)
    by_creation_date(date.beginning_of_month..date.end_of_month)
  end

  def self.by_classification(classification_key)
    where { classification.eq classification_key }
  end

  def used_percent
    0
  end

  def to_s
    "#{regulatory_act_type_humanize} #{act_number}"
  end

  def budget_change_decree_type_required?
    classification_decree? && regulatory_act_type_budget_change?
  end

  def origin_updateable?
    budget_change_decree_type_extra_credit_decree? || budget_change_decree_type_special_credit_decree?
  end

  def budget_change_law_type_required?
    classification_law? && regulatory_act_type_budget_change?
  end

  def additional_percent_required?
    is_law_and_loa_or_budget_change?
  end

  def authorized_value_required?
    is_law_and_loa_or_budget_change_or_decree_and_parent_is_loa_or_budget_change?
  end

  private

  def is_law_and_loa_or_budget_change_or_decree_and_parent_is_loa_or_budget_change?
    is_law_and_loa_or_budget_change? || is_decree_and_parent_is_loa_or_budget_change?
  end

  def is_decree_and_parent_is_loa_or_budget_change?
    classification_decree? && (parent_regulatory_act_type_budget_change? || parent_regulatory_act_type_loa?)
  end

  def is_law_and_loa_or_budget_change?
    classification_law? && (regulatory_act_type_budget_change? || regulatory_act_type_loa?)
  end

  def self.year_period(date)
    (date.beginning_of_year..date)
  end

  def clear_budget_change_decree_type_unless_required
    self.budget_change_decree_type = nil unless budget_change_decree_type_required?
  end

  def clear_origin_unless_updateable
    self.origin = nil unless origin_updateable?
  end

  def clear_budget_change_law_type_unless_required
    self.budget_change_law_type = nil unless budget_change_law_type_required?
  end

  def clear_authorized_value_unless_required
    self.authorized_value = nil unless authorized_value_required?
  end

    def clear_additional_percent_unless_required
    self.additional_percent = nil unless additional_percent_required?
  end
end
