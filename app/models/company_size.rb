class CompanySize < ActiveRecord::Base
  attr_accessible :name, :acronym, :number

  has_many :companies, :dependent => :restrict
  has_many :creditors, :dependent => :restrict

  validates :name, :acronym, :presence => true
  validates :name, :acronym, :uniqueness => { :allow_blank => true }

  filterize
  orderize

  def to_s
    name
  end
end
