class LicitationProcess < ActiveRecord::Base
  attr_accessible :administrative_process_id, :capability_id, :period_id, :payment_method_id, :year, :process_date
  attr_accessible :object_description, :expiration, :readjustment_index, :caution_value, :legal_advice
  attr_accessible :legal_advice_date, :contract_date, :contract_expiration, :observations, :envelope_delivery_date
  attr_accessible :envelope_delivery_time, :envelope_opening_date, :envelope_opening_time, :document_type_ids

  attr_readonly :process, :year

  has_enumeration_for :legal_advice, :with => LicitationProcessLegalAdvice
  has_enumeration_for :modality, :with => AbreviatedProcessModality

  belongs_to :administrative_process
  belongs_to :capability
  belongs_to :period
  belongs_to :payment_method

  has_and_belongs_to_many :document_types

  validates :process_date, :administrative_process, :object_description, :capability, :expiration, :readjustment_index,
            :period, :payment_method, :envelope_delivery_time, :year, :envelope_delivery_date, :envelope_opening_date,
            :envelope_opening_time, :presence => true
  validates :year, :mask => "9999"
  validates :envelope_delivery_date, :timeliness => { :on_or_after => :today, :type => :date }
  validates :envelope_opening_date, :timeliness => { :on_or_after => :envelope_delivery_date, :type => :date }

  delegate :organogram, :modality_humanize, :object_type_humanize, :judgment_form, :description, :responsible,
           :item, :to => :administrative_process, :allow_nil => true, :prefix => true

  before_create :set_process, :set_modality, :set_licitation_number

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
end
