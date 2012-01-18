namespace :import do
  desc 'Import countries'
  task :countries => :environment do
    country_importer = CountryImporter.new
    country_importer.import!
  end
end
