class AdministractiveAct < ActiveRecord::Base
  attr_accessible :act_number, :type_of_administractive_act_id, :creation_date, :legal_text_nature_id,
                  :publication_date, :vigor_date, :end_date, :content, :budget_law_percent,
                  :revenue_antecipation_percent, :authorized_debt_value, :dissemination_source_ids

  attr_protected :type_of_administractive_act, :legal_text_nature

  attr_accessor :dissemination_source

  attr_modal :act_number, :type_of_administractive_act, :legal_text_nature

  belongs_to :type_of_administractive_act
  belongs_to :legal_text_nature

  has_and_belongs_to_many :dissemination_sources

  orderize :act_number
  filterize

  validates :type_of_administractive_act_id, :creation_date, :publication_date, :vigor_date, :end_date, :legal_text_nature_id,
            :content, :budget_law_percent, :revenue_antecipation_percent, :authorized_debt_value, :presence => true
  validates :content, :uniqueness => true
  validates :act_number, :presence => true, :uniqueness => true, :numericality => true
  validates_numericality_of :budget_law_percent, :less_than_or_equal_to => 100
  validates_numericality_of :revenue_antecipation_percent, :less_than_or_equal_to => 100

  validates :vigor_date, :timeliness => { :on_or_after => :creation_date, :type => :date }
  validates :publication_date, :timeliness => { :on_or_after => :creation_date, :type => :date }
  validates :publication_date, :timeliness => { :on_or_before => :vigor_date, :type => :date }

  def to_s
    act_number
  end
end
