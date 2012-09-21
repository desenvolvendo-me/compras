namespace :import do
  desc 'Import account plans'
  task :account_plans => :environment do
    importer = AccountPlanImporter.new
    importer.import!
  end
end
