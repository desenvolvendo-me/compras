class RevenueSource < ActiveRecord::Base
  attr_accessible :code, :description, :revenue_nature_id

  belongs_to :revenue_nature

  has_many :revenue_rubrics, :dependent => :restrict

  validates :code, :description, :revenue_nature, :presence => true
  validates :code, :uniqueness => { :scope => [:revenue_nature_id] }

  def to_s
    "#{code}"
  end
end
