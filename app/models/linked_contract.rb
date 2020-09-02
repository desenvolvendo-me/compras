class LinkedContract < Compras::Model
  attr_accessible :contract_id,:contract_number,:start_date_contract,:end_date_contract,:contract_value

  orderize "id DESC"
  filterize
end
