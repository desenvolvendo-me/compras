class AdministrationType < ActiveRecord::Base
  attr_accessible :description, :administration, :organ_type, :legal_nature_id

  belongs_to :legal_nature
  has_many :organograms, :dependent => :restrict

  orderize :description
  filterize

  validates :administration, :organ_type, :legal_nature_id, :presence => true
  validates :description, :presence => true, :uniqueness => true

  has_enumeration_for :administration, :create_helpers => true
  has_enumeration_for :organ_type, :create_helpers => true

  def to_s
    description
  end
end
