class LinkedContract < Compras::Model
  attr_accessible :contract_id,:contract_number,:start_date_contract,:end_date_contract,:contract_value

  orderize "id DESC"
  filterize
  
  belongs_to :contract

  scope :between_days_finish, lambda { |start_at, end_at|
    where { end_date_contract.gteq(Date.today + start_at.to_i) & end_date_contract.lteq(Date.today + end_at.to_i) }
  }
  
  scope :by_days_finish, lambda { |days = 30|
    where { end_date_contract.gteq(Date.today) & end_date_contract.lteq(Date.today + days.to_i) }
  }

end
