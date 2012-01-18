class ChangeRegistrableStypeToRegistrableTypeAndAddRegistrableIndex < ActiveRecord::Migration
  def change
    rename_column :active_debt_certificates, :registrable_stype, :registrable_type
    add_index :active_debt_certificates, [:registrable_id, :registrable_type], :name => 'certificates_registrable'
  end
end
