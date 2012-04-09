class City < ActiveRecord::Base
  attr_accessible :name, :state_id, :code

  attr_modal :name, :state_id

  belongs_to :state

  has_many :agencies, :dependent => :restrict
  has_many :neighborhoods, :dependent => :restrict
  has_many :districts, :dependent => :restrict

  validates :name, :uniqueness => { :scope => :state_id, :allow_blank => true }
  validates :state, :name, :presence => true

  orderize
  filterize

  def to_s
    name
  end
end
