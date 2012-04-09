class RegulatoryAct < ActiveRecord::Base
  attr_accessible :act_number, :regulatory_act_type_id, :creation_date, :legal_text_nature_id
  attr_accessible :publication_date, :vigor_date, :end_date, :content, :budget_law_percent
  attr_accessible :revenue_antecipation_percent, :authorized_debt_value, :dissemination_source_ids

  attr_modal :act_number, :regulatory_act_type_id, :legal_text_nature_id

  belongs_to :regulatory_act_type
  belongs_to :legal_text_nature

  has_and_belongs_to_many :dissemination_sources

  has_many :expense_elements, :dependent => :restrict
  has_many :budget_unit_configurations, :dependent => :restrict
  has_many :organogram_responsibles, :dependent => :restrict
  has_many :licitation_modalities, :dependent => :restrict
  has_many :licitation_commissions, :dependent => :restrict
  has_many :revenue_natures, :dependent => :restrict

  has_one :extra_credit

  validates :regulatory_act_type, :creation_date, :publication_date, :presence => true
  validates :vigor_date, :end_date, :legal_text_nature, :content, :presence => true
  validates :budget_law_percent, :revenue_antecipation_percent, :presence => true
  validates :authorized_debt_value, :act_number, :presence => true

  with_options :allow_blank => true do |allowed_blank|
    allowed_blank.validates :revenue_antecipation_percent, :numericality => { :less_than_or_equal_to => 100 }
    allowed_blank.validates :budget_law_percent, :numericality => { :less_than_or_equal_to => 100 }
    allowed_blank.validates :act_number, :content, :uniqueness => true
    allowed_blank.validates :act_number, :numericality => true
    allowed_blank.validates :vigor_date, :timeliness => { :on_or_after => :creation_date, :type => :date }
    allowed_blank.validates :publication_date, :timeliness => { :on_or_after => :creation_date, :type => :date }
    allowed_blank.validates :publication_date, :timeliness => { :on_or_before => :vigor_date, :type => :date }
  end

  orderize :act_number
  filterize

  def to_s
    act_number
  end
end
