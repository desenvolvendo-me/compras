class Prefecture < ActiveRecord::Base
  attr_accessible :name, :cnpj, :phone, :fax, :email, :mayor_name, :remove_image
  attr_accessible :address_attributes, :image

  attr_modal :name, :cnpj, :phone, :fax, :email, :mayor_name

  mount_uploader :image

  has_one :address, :as => :addressable, :dependent => :destroy

  accepts_nested_attributes_for :address

  validates :name, :mayor_name, :presence => true
  validates :name, :uniqueness => true, :allow_blank => true
  validates :email, :mail => true, :allow_blank => true
  validates :phone, :fax, :mask => '(99) 9999-9999', :allow_blank => true, :allow_blank => true
  validates :cnpj, :mask => '99.999.999/9999-99', :cnpj => true, :allow_blank => true

  filterize
  orderize

  def to_s
    name
  end
end
