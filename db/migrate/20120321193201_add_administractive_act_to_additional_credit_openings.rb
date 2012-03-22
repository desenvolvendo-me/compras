class AddAdministractiveActToAdditionalCreditOpenings < ActiveRecord::Migration
  def change
    add_column :additional_credit_openings, :administractive_act_id, :integer

    add_index :additional_credit_openings, :administractive_act_id

    add_foreign_key :additional_credit_openings, :administractive_acts
  end
end
