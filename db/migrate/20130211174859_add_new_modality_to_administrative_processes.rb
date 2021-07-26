class AddNewModalityToAdministrativeProcesses < ActiveRecord::Migration
  def change
    add_column :compras_administrative_processes, :new_modality, :string
  end
end
