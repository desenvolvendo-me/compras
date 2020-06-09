class SecretarySetting < Compras::Model
  attr_accessible :secretary_id, :employee_id, :digital_signature,
                  :signature, :authorization_value

  belongs_to :secretary
  belongs_to :employee

  orderize "id DESC"
  filterize

  def to_s
    "#{name}"
  end

end