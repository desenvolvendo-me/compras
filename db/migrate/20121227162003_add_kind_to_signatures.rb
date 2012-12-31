class AddKindToSignatures < ActiveRecord::Migration
  def change
    add_column :compras_signatures, :kind, :string
  end
end
