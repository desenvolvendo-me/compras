def expense_importers
  [
    ExpenseCategoryImporter,
    ExpenseGroupImporter,
    ExpenseModalityImporter,
    ExpenseElementImporter,
    ExpenseNatureImporter,
  ]
end

namespace :import do
  desc 'Import expense nature related models'
  task :expense_natures => :environment do
    ActiveRecord::Base.transaction do
      expense_importers.each do |expense_importer|
        importer = expense_importer.new
        importer.import!
      end
    end
  end
end
