class Function < ActiveRecord::Base
  attr_accessible :code, :administractive_act_id, :description

  belongs_to :administractive_act

  has_many :subfunctions, :dependent => :restrict

  delegate :vigor_date, :to => :administractive_act, :allow_nil => true, :prefix => true

  validates :code, :presence => true, :uniqueness => true, :numericality => true
  validates :description, :presence => true

  orderize :code
  filterize

  def to_s
    "#{code} - #{description}"
  end
end
