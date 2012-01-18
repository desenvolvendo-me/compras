class Agency < ActiveRecord::Base
  attr_accessible :name, :number, :digit, :city_id, :bank_id, :phone, :fax, :email

  attr_modal :name, :number

  belongs_to :city
  belongs_to :bank
  has_many :bank_accounts, :dependent => :restrict

  validates :name, :number, :digit, :city, :bank, :presence => true
  validates :email, :mail => true, :allow_blank => true
  validates :phone, :fax, :mask => "(99) 9999-9999", :allow_blank => true, :allow_nil => true

  scope :bank_id, lambda { |bank_id| where(:bank_id => bank_id) }

  filterize
  orderize

  def to_s
    name
  end
end
