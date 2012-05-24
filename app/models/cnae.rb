class Cnae < ActiveRecord::Base
  attr_accessible :name, :code, :section, :risk_degree_id, :parent_id

  acts_as_nested_set

  belongs_to :risk_degree

  has_many :providers, :dependent => :restrict
  has_many :creditors, :dependent => :restrict, :foreign_key => :main_cnae_id

  validates :name, :code, :presence => true

  filterize
  orderize :code

  def to_s
    name
  end
end
