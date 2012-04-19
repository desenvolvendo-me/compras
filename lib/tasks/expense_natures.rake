namespace :import do
  desc 'Import expense natures'
  task :expense_natures => :environment do
    importer = ExpenseNatureImporter.new
    importer.import!
  end
end
