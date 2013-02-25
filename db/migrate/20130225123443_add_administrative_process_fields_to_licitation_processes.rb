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

    execute <<-SQL
      UPDATE compras_licitation_processes a SET
        protocol = b.protocol,
        item = b.item,
        object_type = b.object_type,
        summarized_object = b.summarized_object,
        description = b.description,
        responsible_id = b.responsible_id,
        purchase_solicitation_item_group_id = b.purchase_solicitation_item_group_id,
        modality = b.modality,
        purchase_solicitation_id = b.purchase_solicitation_id
      FROM compras_administrative_processes b
      WHERE a.administrative_process_id = b.id
    SQL
  end
end
