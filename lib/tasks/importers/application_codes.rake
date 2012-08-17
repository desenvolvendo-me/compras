namespace :import do
  desc 'Import application_codes'
  task :application_codes => :environment do
    importer = ApplicationCodeImporter.new
    importer.import!
  end
end
