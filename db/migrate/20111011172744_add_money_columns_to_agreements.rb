class AddMoneyColumnsToAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :initial_amount_payable,  :decimal, :precision => 10, :scale => 2
    add_column :agreements, :discount_amount_payable, :decimal, :precision => 10, :scale => 2, :default => 0
    add_column :agreements, :final_amount_payable,    :decimal, :precision => 10, :scale => 2
    add_column :agreements, :initial_fine,            :decimal, :precision => 10, :scale => 2
    add_column :agreements, :discount_fine,           :decimal, :precision => 10, :scale => 2, :default => 0
    add_column :agreements, :final_fine,              :decimal, :precision => 10, :scale => 2
    add_column :agreements, :initial_interest,        :decimal, :precision => 10, :scale => 2
    add_column :agreements, :discount_interest,       :decimal, :precision => 10, :scale => 2, :default => 0
    add_column :agreements, :final_interest,          :decimal, :precision => 10, :scale => 2
    add_column :agreements, :initial_correction,      :decimal, :precision => 10, :scale => 2
    add_column :agreements, :discount_correction,     :decimal, :precision => 10, :scale => 2, :default => 0
    add_column :agreements, :final_correction,        :decimal, :precision => 10, :scale => 2
  end
end
