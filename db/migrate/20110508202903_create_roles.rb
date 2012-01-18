class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :controller
      t.string :action

      t.timestamps
    end
  end
end
