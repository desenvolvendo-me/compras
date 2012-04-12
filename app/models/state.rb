class State < ActiveRecord::Base
  attr_accessible :acronym, :name, :country_id

  belongs_to :country

  has_many :cities, :dependent => :destroy

  validates :name, :acronym, :uniqueness => { :allow_blank => true }
  validates :country, :name, :acronym, :presence => true
  validates :acronym, :mask => "aa", :allow_blank => true

  filterize
  orderize

  def to_s
    name
  end
end
