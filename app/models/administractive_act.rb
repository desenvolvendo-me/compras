class AdministractiveAct < ActiveRecord::Base
  attr_accessible :act_number, :type_of_administractive_act_id, :text_legal_nature, :creation_date,
                  :publication_date, :vigor_date, :end_date, :content, :budget_law_percent,
                  :revenue_antecipation_percent, :authorized_debt_value, :dissemination_source_ids

  attr_protected :type_of_administractive_act

  attr_accessor :dissemination_source

  belongs_to :type_of_administractive_act

  has_and_belongs_to_many :dissemination_sources

  orderize :act_number
  filterize

  accepts_nested_attributes_for :dissemination_sources

  validates :act_number, :type_of_administractive_act_id, :creation_date, :publication_date, :vigor_date, :end_date,
            :content, :budget_law_percent, :revenue_antecipation_percent, :authorized_debt_value, :presence => true
  validates :act_number, :content, :uniqueness => true

  validate :vigor_date_cannot_be_small_than_creation_date
  validate :publication_date_cannot_be_small_than_creation_date
  validate :publication_date_cannot_be_greater_than_vigor_date

  def to_s
    act_number
  end

  protected

  def vigor_date_cannot_be_small_than_creation_date
    if vigor_date && creation_date && self.vigor_date < self.creation_date
      errors.add(:vigor_date, I18n.translate('errors.messages.cannot_be_small_than_creation_date'))
    end
  end

  def publication_date_cannot_be_small_than_creation_date
    if publication_date && creation_date && self.publication_date < self.creation_date
      errors.add(:publication_date, I18n.translate('errors.messages.cannot_be_small_than_creation_date'))
    end
  end

  def publication_date_cannot_be_greater_than_vigor_date
    if publication_date && vigor_date && self.publication_date > self.vigor_date
      errors.add(:publication_date, I18n.translate('errors.messages.cannot_be_greater_than_vigor_date'))
    end
  end
end
