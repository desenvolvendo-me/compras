class LicitationProcess < ActiveRecord::Base
  attr_accessible :administrative_process_id, :capability_id, :period_id, :payment_method_id, :year, :process_date
  attr_accessible :object_description, :expiration, :readjustment_index, :caution_value, :legal_advice
  attr_accessible :legal_advice_date, :contract_date, :contract_expiration, :observations, :envelope_delivery_date
  attr_accessible :envelope_delivery_time, :envelope_opening_date, :envelope_opening_time, :document_type_ids
  attr_accessible :licitation_process_publications_attributes
  attr_accessible :licitation_process_invited_bidders_attributes, :pledge_type, :administrative_process_attributes

  attr_readonly :process, :year, :licitation_number

  has_enumeration_for :legal_advice, :with => LicitationProcessLegalAdvice
  has_enumeration_for :modality, :with => AbreviatedProcessModality, :create_helpers => true
  has_enumeration_for :pledge_type

  belongs_to :administrative_process
  belongs_to :capability
  belongs_to :period
  belongs_to :payment_method

  has_and_belongs_to_many :document_types

  has_many :administrative_process_budget_allocations, :through => :administrative_process
  has_many :licitation_process_publications, :dependent => :destroy, :order => :id
  has_many :licitation_process_invited_bidders, :dependent => :destroy, :order => :id
  has_many :licitation_process_invited_bidder_documents, :through => :licitation_process_invited_bidders
  has_many :licitation_process_impugnments, :dependent => :restrict, :order => :id
  has_many :licitation_process_appeals, :dependent => :restrict

  has_one :accreditation, :dependent => :destroy

  accepts_nested_attributes_for :licitation_process_publications, :allow_destroy => true
  accepts_nested_attributes_for :licitation_process_invited_bidders, :allow_destroy => true

  accepts_nested_attributes_for :administrative_process, :allow_destroy => true

  delegate :budget_unit, :modality, :modality_humanize, :object_type_humanize, :judgment_form, :description, :responsible,
           :item, :licitation_process, :to => :administrative_process, :allow_nil => true, :prefix => true

  delegate :administrative_process_budget_allocations, :to => :administrative_process, :allow_nil => true

  validates :process_date, :administrative_process, :object_description, :capability, :expiration, :presence => true
  validates :readjustment_index, :period, :payment_method, :envelope_delivery_time, :year, :presence => true
  validates :envelope_delivery_date, :envelope_opening_date, :envelope_opening_time, :pledge_type, :presence => true
  validate :cannot_have_duplicated_invited_bidders
  validate :total_of_administrative_process_budget_allocations_items_must_be_equal_to_value
  validate :administrative_process_must_not_belong_to_another_licitation_process

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :year, :mask => "9999"
    allowing_blank.validates :envelope_delivery_date, :timeliness => { :on_or_after => :today, :type => :date, :on => :create }
    allowing_blank.validates :envelope_opening_date, :timeliness => { :on_or_after => :envelope_delivery_date, :type => :date, :on => :create }
    allowing_blank.validates :envelope_delivery_time, :envelope_opening_time, :timeliness => { :type => :time }
  end

  before_save :set_modality, :clear_bidders_depending_on_modality

  before_update :clean_old_administrative_process_items

  orderize :id
  filterize

  def to_s
    "#{process}/#{year}"
  end

  def set_dates(dates={})
    if dates[:envelope_delivery_date] && dates[:envelope_delivery_time] && dates[:envelope_opening_date]  && dates[:envelope_opening_time]
      update_attributes(dates)
    end
  end

  def next_process
    last_process_of_self_year.succ
  end

  def next_licitation_number
    last_licitation_number_of_self_year_and_modality.succ
  end

  protected

  def set_modality
    self.modality = administrative_process.modality
  end

  def clear_bidders_depending_on_modality
    unless invitation_for_constructions_engineering_services? || invitation_for_purchases_and_engineering_services?
      licitation_process_invited_bidders.each(&:destroy)
    end
  end

  def last_process_of_self_year
    last_by_self_year.try(:process).to_i
  end

  def last_by_self_year
    self.class.where { |p| p.year.eq(year) }.order { id }.last
  end

  def last_licitation_number_of_self_year_and_modality
    last_by_self_year_and_modality.try(:licitation_number).to_i
  end

  def last_by_self_year_and_modality
    self.class.where { |p| p.year.eq(year) & p.modality.eq(modality) }.
               order { id }.last
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

  def total_of_administrative_process_budget_allocations_items_must_be_equal_to_value
    return if administrative_process_budget_allocations.blank?

    administrative_process_budget_allocations.each do |apba|
      if apba.total_items_value != apba.value
        errors.add(:administrative_process_budget_allocations)
        apba.errors.add(:total_items_value, :must_be_equal_to_estimated_value)
      end
    end
  end

  def administrative_process_must_not_belong_to_another_licitation_process
    return if administrative_process.nil? || administrative_process_licitation_process == self

    unless administrative_process_licitation_process.nil?
      errors.add(:administrative_process, :taken)
    end
  end

  def clean_old_administrative_process_items
    if administrative_process_id_changed?
      AdministrativeProcessItemsCleaner.new(administrative_process_id_was).clean_items!
    end
  end
end
