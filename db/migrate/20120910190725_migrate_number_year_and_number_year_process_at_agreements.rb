class MigrateNumberYearAndNumberYearProcessAtAgreements < ActiveRecord::Migration
  class Agreement < Compras::Model
  end

  def change
    Agreement.find_each do |agreement|
      agreement.update_column(:number_year, [agreement.number, agreement.year].join('/'))
      agreement.update_column(:number_year_process, [agreement.process_number, agreement.process_year].join('/'))
    end
  end
end
