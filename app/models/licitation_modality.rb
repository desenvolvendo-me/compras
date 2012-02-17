class LicitationModality < ActiveRecord::Base
  attr_accessible :administractive_act_id, :description, :initial_value, :final_value

  delegate :publication_date, :to => :administractive_act, :prefix => true, :allow_nil => true

  belongs_to :administractive_act

  orderize :description
  filterize

  validates :description, :presence => true
  validates :initial_value, :numericality => { :less_than => :final_value }

  def to_s
    description
  end
end
