class AddPeriodToDescriptors < ActiveRecord::Migration
  class Descriptor < Compras::Model
  end

  def change
    add_column :compras_descriptors, :period, :date

    Descriptor.all.each do |descriptor|
      period = Date.new(descriptor.year, Date.current.month, 1)

      descriptor.update_column(:period, period)
    end
  end
end
