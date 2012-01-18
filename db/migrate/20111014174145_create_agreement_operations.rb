class CreateAgreementOperations < ActiveRecord::Migration
  def change
    create_table :agreement_operations do |t|
      t.integer  :motive_id
      t.integer  :parcel_number
      t.date     :date_agreement
      t.text     :comment
      t.string   :status
      t.string   :process
      t.date     :cancel_date
      t.integer  :currency_id
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :parcel_debt_setting_id
      t.integer  :year
      t.date     :due_date
      t.decimal  :max_value,                 :precision => 10, :scale => 2
      t.decimal  :min_value,                 :precision => 10, :scale => 2
      t.date     :initial_due_date
      t.decimal  :tribute_value,             :precision => 10, :scale => 2
      t.decimal  :correction_value,          :precision => 10, :scale => 2
      t.decimal  :interest_value,            :precision => 10, :scale => 2
      t.decimal  :fine_value,                :precision => 10, :scale => 2
      t.decimal  :real_tribute_value,        :precision => 10, :scale => 2
      t.decimal  :discount_tribute_value,    :precision => 10, :scale => 2
      t.decimal  :discount_correction_value, :precision => 10, :scale => 2
      t.decimal  :discount_interest_value,   :precision => 10, :scale => 2
      t.decimal  :discount_fine_value,       :precision => 10, :scale => 2
    end
  end
end
