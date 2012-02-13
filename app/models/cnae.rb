class Cnae < ActiveRecord::Base
  attr_accessible :name, :code, :section, :risk_degree_id, :parent_id

  attr_modal :name, :code

  acts_as_nested_set

  belongs_to :risk_degree

  validates :name, :code, :presence => true

  filterize
  orderize :code

  def to_s
    name
  end
end
