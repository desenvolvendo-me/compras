class Function < ActiveRecord::Base
  attr_accessible :code, :regulatory_act_id, :description

  belongs_to :regulatory_act

  has_many :subfunctions, :dependent => :restrict

  delegate :vigor_date, :to => :regulatory_act, :allow_nil => true, :prefix => true

  validates :code, :presence => true, :numericality => true
  validates :code, :uniqueness => { :scope => :regulatory_act_id, :message => :taken_for_regulatory_act }
  validates :description, :presence => true

  orderize :code
  filterize

  def to_s
    "#{code} - #{description}"
  end
end
