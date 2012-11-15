class Prefecture < Unico::Prefecture
  attr_modal :name, :cnpj, :phone, :fax, :email, :mayor_name

  filterize
  orderize
end
