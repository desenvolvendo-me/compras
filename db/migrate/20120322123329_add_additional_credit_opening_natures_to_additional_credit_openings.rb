class AddAdditionalCreditOpeningNaturesToAdditionalCreditOpenings < ActiveRecord::Migration
  def change
    add_column :additional_credit_openings, :additional_credit_opening_nature_id, :integer

    add_index :additional_credit_openings, :additional_credit_opening_nature_id, :name => :aco_acon_idx

    add_foreign_key :additional_credit_openings, :additional_credit_opening_natures, :name => :aco_acon_id_fk
  end
end
