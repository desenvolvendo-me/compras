class RemoveRegistrableFromInstallmentTerms < ActiveRecord::Migration
  def change
    change_table :installment_terms do |t|
      t.remove :registrable_id
      t.remove :registrable_stype
    end
  end
end
