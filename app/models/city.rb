class City < ActiveRecord::Base
  attr_accessible :name, :state_id, :code

  attr_modal :name, :state_id

  belongs_to :state

  has_many :agencies, :dependent => :restrict
  has_many :neighborhoods, :dependent => :restrict
  has_many :districts, :dependent => :restrict

  validates :name, :presence => true, :uniqueness => { :scope => [:state_id] }
  validates :state, :presence => true

  filterize
  orderize

  def to_s
    name
  end
end
