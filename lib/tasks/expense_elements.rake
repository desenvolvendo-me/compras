namespace :import do
  desc 'Import expense elements'
  task :expense_elements => :environment do
    importer = ExpenseElementImporter.new
    importer.import!
  end
end
