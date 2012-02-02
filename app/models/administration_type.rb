class AdministrationType < ActiveRecord::Base
  attr_accessible :name, :administration, :organ_type, :legal_nature_id

  belongs_to :legal_nature

  orderize
  filterize

  validates :name, :administration, :organ_type, :legal_nature_id, :presence => true
  validates :name, :uniqueness => true

  has_enumeration_for :administration, :create_helpers => true
  has_enumeration_for :organ_type, :create_helpers => true

  def to_s
    name
  end
end
