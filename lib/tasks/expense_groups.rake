namespace :import do
  desc 'Import expense groups'
  task :expense_groups => :environment do
    importer = ExpenseGroupImporter.new
    importer.import!
  end
end
