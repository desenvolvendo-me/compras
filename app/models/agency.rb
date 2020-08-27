# frozen_string_literal: true

class Agency < Unico::Agency
  attr_accessible  :bank_id, :name, :number, :digit, :phone, :fax, :email

  orderize
  filterize

end
