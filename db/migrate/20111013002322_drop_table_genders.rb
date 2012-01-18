class DropTableGenders < ActiveRecord::Migration
  def change
    drop_table :genders
  end
end
