class CreateEventCheckingConfigurations < ActiveRecord::Migration
  def change
    create_table :compras_event_checking_configurations do |t|
      t.references :descriptor
      t.string :event
      t.string :function

      t.timestamps
    end

    add_index :compras_event_checking_configurations, :descriptor_id

    add_foreign_key :compras_event_checking_configurations, :compras_descriptors,
                    :column => :descriptor_id, :name => :cecc_descriptors_fk
  end
end
