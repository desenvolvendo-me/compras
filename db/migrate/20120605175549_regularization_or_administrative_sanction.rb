class RegularizationOrAdministrativeSanction < ActiveRecord::Migration
  def change
    create_table :regularization_or_administrative_sanctions do |t|
      t.references :creditor
      t.references :regularization_or_administrative_sanction_reason
      t.date :suspended_until
      t.date :occurrence
    end

    add_index :regularization_or_administrative_sanctions, :creditor_id
    add_index :regularization_or_administrative_sanctions, :regularization_or_administrative_sanction_reason_id, :name => :index_regul_or_admin_sanct_on_regular_or_admin_sanct_reason_id
    add_foreign_key :regularization_or_administrative_sanctions, :creditors
    add_foreign_key :regularization_or_administrative_sanctions, :regularization_or_administrative_sanction_reasons, :name => :regularization_or_administrative_sanction_reasons_fk
  end
end
