class MigrateNumberYearAndNumberYearProcessAtAgreements < ActiveRecord::Migration
  class Agreement < Compras::Model
  end

  def change
    Agreement.find_each do |agreement|
      agreement.number_year = [agreement.number, agreement.year].join('/')
      agreement.number_year_process = [agreement.process_number, agreement.process_year].join('/')
      agreement.save(:validate => false)
    end
  end
end
