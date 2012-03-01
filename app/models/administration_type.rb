class AdministrationType < ActiveRecord::Base
  attr_accessible :description, :administration, :organ_type, :legal_nature_id

  has_enumeration_for :administration, :create_helpers => true
  has_enumeration_for :organ_type, :create_helpers => true

  belongs_to :legal_nature

  has_many :organograms, :dependent => :restrict

  validates :administration, :organ_type, :legal_nature, :presence => true
  validates :description, :presence => true, :uniqueness => true

  orderize :description
  filterize

  def to_s
    description
  end
end
