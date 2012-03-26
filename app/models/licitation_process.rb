class LicitationProcess < ActiveRecord::Base
  attr_accessible :administrative_process_id, :capability_id, :period_id, :payment_method_id, :year, :process_date
  attr_accessible :object_description, :expiration, :readjustment_index, :caution_value, :legal_advice
  attr_accessible :legal_advice_date, :contract_date, :contract_expiration, :observations, :envelope_delivery_date
  attr_accessible :envelope_delivery_time, :envelope_opening_date, :envelope_opening_time, :document_type_ids
  attr_accessible :licitation_process_budget_allocations_attributes, :licitation_process_publications_attributes
  attr_accessible :licitation_process_invited_bidders_attributes

  attr_readonly :process, :year

  has_enumeration_for :legal_advice, :with => LicitationProcessLegalAdvice
  has_enumeration_for :modality, :with => AbreviatedProcessModality

  belongs_to :administrative_process
  belongs_to :capability
  belongs_to :period
  belongs_to :payment_method

  has_and_belongs_to_many :document_types

  has_many :licitation_process_budget_allocations, :dependent => :destroy, :order => :id
  has_many :licitation_process_publications, :dependent => :destroy, :order => :id
  has_many :licitation_process_invited_bidders, :dependent => :destroy, :order => :id

  accepts_nested_attributes_for :licitation_process_budget_allocations, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :licitation_process_publications, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :licitation_process_invited_bidders, :reject_if => :all_blank, :allow_destroy => true

  delegate :organogram, :modality_humanize, :object_type_humanize, :judgment_form, :description, :responsible,
           :item, :to => :administrative_process, :allow_nil => true, :prefix => true

  validates :process_date, :administrative_process, :object_description, :capability, :expiration, :readjustment_index,
            :period, :payment_method, :envelope_delivery_time, :year, :envelope_delivery_date, :envelope_opening_date,
            :envelope_opening_time, :presence => true
  validates :year, :mask => "9999"
  validates :envelope_delivery_date, :timeliness => { :on_or_after => :today, :type => :date }
  validates :envelope_opening_date, :timeliness => { :on_or_after => :envelope_delivery_date, :type => :date }

  validate :cannot_have_duplicated_budget_allocations
  validate :cannot_have_duplicated_invited_bidders

  before_create :set_process, :set_licitation_number

  before_save :set_modality, :clear_bidders_depending_on_modality

  orderize :id
  filterize

  def to_s
    "#{process}/#{year}"
  end

  protected

  def set_process
    last = self.class.where(:year => year).last

    if last
      self.process = last.process.to_i + 1
    else
      self.process = 1
    end
  end

  def set_modality
    self.modality = administrative_process.modality
  end

  def set_licitation_number
    last = self.class.where(:year => year, :administrative_process_id => administrative_process_id).last

    if last
      self.licitation_number = last.licitation_number.to_i + 1
    else
      self.licitation_number = 1
    end
  end

  def clear_bidders_depending_on_modality
    unless [AdministrativeProcessModality::INVITATION_FOR_CONSTRUCTIONS_ENGINEERING_SERVICES,
            AdministrativeProcessModality::INVITATION_FOR_PURCHASES_AND_ENGINEERING_SERVICES].include?(modality)
      licitation_process_invited_bidders.each(&:destroy)
    end
  end

  def cannot_have_duplicated_budget_allocations
    single_allocations = []

    licitation_process_budget_allocations.each do |allocation|
      if single_allocations.include?(allocation.budget_allocation_id)
        errors.add(:licitation_process_budget_allocations)
        allocation.errors.add(:budget_allocation_id, :taken)
      end
      single_allocations << allocation.budget_allocation_id
    end
  end

  def cannot_have_duplicated_invited_bidders
    single_bidders = []

    licitation_process_invited_bidders.each do |bidder|
      if single_bidders.include?(bidder.provider_id)
        errors.add(:licitation_process_invited_bidders)
        bidder.errors.add(:provider_id, :taken)
      end
      single_bidders << bidder.provider_id
    end
  end
end
