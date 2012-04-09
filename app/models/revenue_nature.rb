class RevenueNature < ActiveRecord::Base
  attr_accessible :regulatory_act_id, :classification, :revenue_rubric_id
  attr_accessible :specification, :kind, :docket, :entity_id, :year

  has_enumeration_for :kind, :with => RevenueNatureKind

  belongs_to :entity
  belongs_to :regulatory_act
  belongs_to :revenue_rubric

  validates :regulatory_act, :kind, :docket, :revenue_rubric, :presence => true
  validates :specification, :entity, :presence => true
  validates :year, :presence => true, :mask => '9999'
  validates :classification, :presence => true, :mask => '99999999'

  delegate :publication_date, :regulatory_act_type, :to => :regulatory_act, :allow_nil => true
  delegate :full_code, :to => :revenue_rubric, :prefix => true, :allow_nil => true

  orderize :id
  filterize

  before_save :generate_full_code

  def to_s
    id.to_s
  end

  protected

  def generate_full_code
    self.full_code = [revenue_rubric_full_code, classification].reject(&:blank?).join('.')
  end
end
