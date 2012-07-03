namespace :import do
  desc 'Import expense categories'
  task :expense_categories => :environment do
    importer = ExpenseCategoryImporter.new
    importer.import!
  end
end
