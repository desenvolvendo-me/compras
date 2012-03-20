class AddModalityToLicitationProcess < ActiveRecord::Migration
  def change
    add_column :licitation_processes, :licitation_number, :integer
    add_column :licitation_processes, :modality, :string

    add_index :licitation_processes, [:licitation_number, :modality, :year], :unique => true, :name => 'lpmy_licitation_number_index'
  end
end
