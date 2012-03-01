class Agency < ActiveRecord::Base
  attr_accessible :name, :number, :digit, :city_id, :bank_id, :phone, :fax, :email

  attr_modal :name, :number, :bank_id

  belongs_to :city
  belongs_to :bank

  has_many :bank_accounts, :dependent => :restrict
  has_many :providers, :dependent => :restrict

  validates :name, :number, :digit, :city, :bank, :presence => true
  validates :email, :mail => true, :allow_blank => true
  validates :phone, :fax, :mask => "(99) 9999-9999", :allow_blank => true, :allow_nil => true

  filterize
  orderize

  scope :bank_id, lambda { |bank_id| where(:bank_id => bank_id) }

  def to_s
    name
  end
end
