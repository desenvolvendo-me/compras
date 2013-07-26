class AddColumnConsortiumAgreementInContract < ActiveRecord::Migration
  def up
    add_column :compras_contracts, :consortium_agreement, :boolean, default: false
  end

  def down
    remove_column :compras_contracts, :consortium_agreement
  end
end
