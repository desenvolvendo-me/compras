class RemoveSummarizedObjectFromTradings < ActiveRecord::Migration
  def change
    remove_column :compras_tradings, :summarized_object
  end
end
