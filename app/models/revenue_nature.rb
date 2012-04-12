class RevenueNature < ActiveRecord::Base
  attr_accessible :regulatory_act_id, :classification, :revenue_rubric_id
  attr_accessible :specification, :kind, :docket, :entity_id, :year

  has_enumeration_for :kind, :with => RevenueNatureKind

  belongs_to :entity
  belongs_to :regulatory_act
  belongs_to :revenue_rubric

  delegate :publication_date, :regulatory_act_type, :to => :regulatory_act, :allow_nil => true
  delegate :full_code, :to => :revenue_rubric, :prefix => true, :allow_nil => true

  validates :regulatory_act, :kind, :docket, :revenue_rubric, :presence => true
  validates :specification, :entity, :year, :classification, :presence => true
  validates :year, :mask => '9999', :allow_blank => true
  validates :classification, :mask => '99999999', :allow_blank => true

  orderize :id
  filterize

  before_save :generate_full_code

  def to_s
    "#{full_code} - #{specification}"
  end

  protected

  def generate_full_code
    self.full_code = [revenue_rubric_full_code, classification].reject(&:blank?).join('.')
  end
end
