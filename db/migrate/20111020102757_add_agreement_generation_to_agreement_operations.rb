class AddAgreementGenerationToAgreementOperations < ActiveRecord::Migration
  def change
    add_column :agreement_operations, :agreement_generation, :boolean, :default => false
  end
end
