class AddRecoverableToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.recoverable
    end
  end
end
