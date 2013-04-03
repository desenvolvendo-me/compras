class RegulatoryAct < Compras::Model
  attr_accessible :act_number, :regulatory_act_type_id, :creation_date,
                  :legal_text_nature_id, :publication_date, :vigor_date,
                  :end_date, :content, :budget_law_percent, :signature_date,
                  :revenue_antecipation_percent, :authorized_debt_value,
                  :dissemination_source_ids

  attr_modal :act_number, :regulatory_act_type_id, :legal_text_nature_id

  belongs_to :regulatory_act_type
  belongs_to :legal_text_nature

  has_and_belongs_to_many :dissemination_sources, :join_table => :compras_dissemination_sources_compras_regulatory_acts

  has_many :expense_natures, :dependent => :restrict
  has_many :budget_structure_configurations, :dependent => :restrict
  has_many :budget_structure_responsibles, :dependent => :restrict
  has_many :licitation_commissions, :dependent => :restrict

  validates :regulatory_act_type, :creation_date, :publication_date, :content,
            :signature_date, :vigor_date, :legal_text_nature, :act_number,
            :presence => true

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :revenue_antecipation_percent, :numericality => { :less_than_or_equal_to => 100 }
    allowing_blank.validates :budget_law_percent, :numericality => { :less_than_or_equal_to => 100 }
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

  orderize :act_number
  filterize

  def to_s
    "#{regulatory_act_type} #{act_number}"
  end
end
