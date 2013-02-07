class Prefecture < Unico::Prefecture
  attr_accessible :setting_attributes

  attr_modal :name, :cnpj, :phone, :fax, :email, :mayor_name

  has_one :setting, :dependent => :destroy, :inverse_of => :prefecture

  accepts_nested_attributes_for :setting

  delegate :allow_insert_past_processes, :to => :setting, :allow_nil => true
  delegate :state, :to => :address, :allow_nil => true
  delegate :id, :to => :state, :allow_nil => true, :prefix => true

  filterize
  orderize
end
