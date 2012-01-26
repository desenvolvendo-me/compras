class CreateCommunicationSources < ActiveRecord::Migration
  def change
    create_table :communication_sources do |t|
      t.string :description

      t.timestamps
    end
  end
end
