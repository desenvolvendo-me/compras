class CreateSignatureConfigurations < ActiveRecord::Migration
  def change
    create_table :signature_configurations do |t|
      t.string :report

      t.timestamps
    end
  end
end
