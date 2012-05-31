class DisseminationSource < ActiveRecord::Base
  attr_accessible :description, :communication_source_id

  belongs_to :communication_source

  has_and_belongs_to_many :regulatory_acts

  validates :description, :communication_source, :presence => true
  validates :description, :uniqueness => { :allow_blank => true }

  before_destroy :validate_regulatory_act_relationship

  filterize
  orderize :description

  def to_s
    description
  end

  protected

  def validate_regulatory_act_relationship
    return unless regulatory_acts.any?

    errors.add(:base, :cant_be_destroyed)

    false
  end
end
