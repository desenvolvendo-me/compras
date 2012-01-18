class CreateLinks < ActiveRecord::Migration
  def up
    create_table :links do |t|
      t.string  :controller_name
    end
  end

  def down
    drop_table :links
  end
end
