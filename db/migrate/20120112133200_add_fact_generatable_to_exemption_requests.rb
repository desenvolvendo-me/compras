class AddFactGeneratableToExemptionRequests < ActiveRecord::Migration
  def change
    add_column :exemption_requests, :fact_generatable_id, :integer
    add_column :exemption_requests, :fact_generatable_type, :string

    add_index :exemption_requests, [:fact_generatable_id, :fact_generatable_type], :name => "idx_fact_generatable_id_and_fact_generatable_type"
  end
end
