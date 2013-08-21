class Prefecture < Unico::Prefecture
  attr_accessible :setting_attributes, :extended_prefecture_attributes

  attr_modal :name, :cnpj, :phone, :fax, :email, :mayor_name

  has_one :setting, :dependent => :destroy, :inverse_of => :prefecture
  has_one :extended_prefecture, dependent: :destroy, inverse_of: :prefecture

  accepts_nested_attributes_for :setting, :extended_prefecture

  delegate :allow_insert_past_processes, :to => :setting, :allow_nil => true
  delegate :city, :state, :to => :address, :allow_nil => true
  delegate :id, :to => :state, :allow_nil => true, :prefix => true
  delegate :tce_mg_code, to: :city, allow_nil: true
  delegate :organ_code, :organ_kind, :control_fractionation,
    to: :extended_prefecture, allow_nil: true

  filterize
  orderize

  def extended_prefecture
    super || create_extended_prefecture
  end
end
