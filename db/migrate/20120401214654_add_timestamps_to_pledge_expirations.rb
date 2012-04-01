class AddTimestampsToPledgeExpirations < ActiveRecord::Migration
  def change
    change_table :pledge_expirations do |t|
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
