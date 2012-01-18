class RemovePrefectureIdFromPayments < ActiveRecord::Migration
  def change
    remove_column :payments, :prefecture_id
  end
end
