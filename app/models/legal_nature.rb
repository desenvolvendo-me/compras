class LegalNature < ActiveRecord::Base
  attr_readonly :code, :name, :parent_id

  acts_as_nested_set

  has_many :administration_types, :dependent => :restrict
  has_many :providers, :dependent => :restrict

  validates :name, :code, :presence => true

  filterize
  orderize :created_at

  def to_s
    name
  end
end
