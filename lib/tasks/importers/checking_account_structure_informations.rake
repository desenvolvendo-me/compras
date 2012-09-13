namespace :import do
  desc 'Import checking_account_structure_informations'
  task :checking_account_structure_informations => :environment do
    importer = CheckingAccountStructureInformationImporter.new
    importer.import!
  end
end
