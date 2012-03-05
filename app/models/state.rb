class State < ActiveRecord::Base
  attr_accessible :acronym, :name, :country_id

  attr_modal :name

  belongs_to :country

  has_many :cities, :dependent => :destroy

  validates :name, :acronym, :presence => true, :uniqueness => { :allow_blank => true }
  validates :country, :presence => true
  validates :acronym, :mask => "aa"

  filterize
  orderize

  def to_s
    name
  end
end
