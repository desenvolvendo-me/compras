class AddColumnConsortiumAgreementInContract < ActiveRecord::Migration
  def change
    add_column :compras_contracts, :consortium_agreement, :boolean, default: false
  end
end
