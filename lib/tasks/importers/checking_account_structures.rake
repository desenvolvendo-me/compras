namespace :import do
  desc 'Import checking_account_structures'
  task :checking_account_structures => :environment do
    importer = CheckingAccountStructureImporter.new
    importer.import!
  end
end
