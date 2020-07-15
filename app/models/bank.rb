# frozen_string_literal: true

class Bank < Unico::Bank
  attr_accessible  :name, :code

  orderize
  filterize

end
