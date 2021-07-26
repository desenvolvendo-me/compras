class UserPurchasingUnit < Compras::Model
  belongs_to :user
  belongs_to :purchasing_unit

  attr_accessible :user_id, :purchasing_unit_id
end
