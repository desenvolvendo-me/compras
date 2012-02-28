class LicitationModality < ActiveRecord::Base
  attr_accessible :administractive_act_id, :description, :initial_value
  attr_accessible :final_value

  belongs_to :administractive_act

  has_many :pledges, :dependent => :restrict
  has_many :reserve_funds, :dependent => :restrict

  delegate :publication_date, :to => :administractive_act, :prefix => true, :allow_nil => true

  validates :description, :administractive_act, :presence => true
  validates :initial_value, :presence => true, :numericality => true
  validates :final_value, :presence => true
  validates :final_value, :numericality => true
  validates :final_value, :numericality => { :greater_than_or_equal_to => :initial_value, :message => :should_not_be_less_than_initial_value }
  validates :initial_value, :uniqueness => { :scope => :final_value, :message => :initial_and_final_value_range_taken }

  orderize :description
  filterize

  def to_s
    description
  end
end
