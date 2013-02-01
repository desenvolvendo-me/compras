class Prefecture < Unico::Prefecture
  attr_accessible :setting_attributes

  attr_modal :name, :cnpj, :phone, :fax, :email, :mayor_name

  has_one :setting, :dependent => :destroy, :inverse_of => :prefecture

  accepts_nested_attributes_for :setting

  filterize
  orderize
end
