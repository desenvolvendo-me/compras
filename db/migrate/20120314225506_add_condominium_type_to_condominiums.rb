class AddCondominiumTypeToCondominiums < ActiveRecord::Migration
  def change
    add_column :condominiums, :condominium_type, :string
  end
end
