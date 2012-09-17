class RemoveCodeFromAgreements < ActiveRecord::Migration
  def change
    remove_column :compras_agreements, :code
  end
end
