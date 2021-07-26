class AddImportedToProcessResponsibles < ActiveRecord::Migration
  def change
    add_column :compras_process_responsibles, :imported, :boolean, default: false
  end
end
