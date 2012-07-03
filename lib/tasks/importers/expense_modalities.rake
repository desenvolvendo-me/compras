namespace :import do
  desc 'Import expense modalities'
  task :expense_modalities => :environment do
    importer = ExpenseModalityImporter.new
    importer.import!
  end
end
