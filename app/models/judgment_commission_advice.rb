class JudgmentCommissionAdvice < ActiveRecord::Base
  attr_accessible :licitation_process_id, :licitation_commission_id, :year, :minutes_number
  attr_accessible :judgment_commission_advice_members_attributes
  attr_accessible :judgment_start_date, :judgment_start_time, :judgment_end_date
  attr_accessible :judgment_end_time, :companies_minutes, :companies_documentation_minutes
  attr_accessible :justification_minutes, :judgment_minutes

  belongs_to :licitation_process
  belongs_to :licitation_commission

  has_many :judgment_commission_advice_members, :dependent => :destroy, :order => :id

  accepts_nested_attributes_for :judgment_commission_advice_members, :allow_destroy => true

  delegate :modality_humanize, :to => :licitation_process, :allow_nil => true, :prefix => true
  delegate :next_judgment_commission_advice, :to => :licitation_process, :allow_nil => true, :prefix => true
  delegate :president_name, :to => :licitation_commission, :allow_nil => true, :prefix => true
  delegate :licitation_commission_members, :to => :licitation_commission, :allow_nil => true

  validates :licitation_process, :licitation_commission, :year, :minutes_number, :presence => true
  validates :year, :mask => "9999"
  validates :judgment_start_date, :judgment_start_time, :judgment_end_date, :presence => true
  validates :judgment_end_time, :companies_minutes, :companies_documentation_minutes, :presence => true
  validates :justification_minutes, :judgment_minutes, :presence => true

  validate :cannot_have_duplicated_individuals_on_members

  orderize :id
  filterize

  def to_s
    "#{id}/#{year}"
  end

  def next_minutes_number
    last_minutes_number_of_self_year.succ
  end

  def not_inherited_members
    judgment_commission_advice_members.reject do |member|
      inherited_members_to_hash.include? member.to_hash
    end
  end

  def inherited_members
    judgment_commission_advice_members.select do |member|
      inherited_members_to_hash.include? member.to_hash
    end
  end

  protected

  def last_minutes_number_of_self_year
    last_by_self_year.try(:minutes_number).to_i
  end

  def last_by_self_year
    self.class.where { |p| p.year.eq(year) }.order { id }.last
  end

  def cannot_have_duplicated_individuals_on_members
    single_individuals = []

    judgment_commission_advice_members.each do |responsible|
      if single_individuals.include?(responsible.individual_id)
        errors.add(:judgment_commission_advice_members)
        responsible.errors.add(:individual_id, :taken)
      end
      single_individuals << responsible.individual_id
    end
  end

  def inherited_members_to_hash
    return [] unless licitation_commission_members

    licitation_commission_members.collect(&:to_hash)
  end
end
