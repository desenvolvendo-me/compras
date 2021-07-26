class AddAdministrativeProcessFieldsToLicitationProcesses < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :protocol,                            :string
    add_column :compras_licitation_processes, :item,                                :string
    add_column :compras_licitation_processes, :object_type,                         :string
    add_column :compras_licitation_processes, :summarized_object,                   :string
    add_column :compras_licitation_processes, :modality,                            :string
    add_column :compras_licitation_processes, :description,                         :text
    add_column :compras_licitation_processes, :responsible_id,                      :integer
    add_column :compras_licitation_processes, :purchase_solicitation_item_group_id, :integer
    add_column :compras_licitation_processes, :purchase_solicitation_id,            :integer
  end
end
