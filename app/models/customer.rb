class Customer < ActiveRecord::Base
  attr_accessible :name, :domain, :database

  serialize :database

  validates :name, :domain, :database, :presence => true
  validates :name, :domain, :uniqueness => { :allow_blank => true }

  filterize
  orderize

  def to_s
    name
  end

  def using_connection(&block)
    ActiveRecord::Base.using_connection(id, database, &block)
  end
end
