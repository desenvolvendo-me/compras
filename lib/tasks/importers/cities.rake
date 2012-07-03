namespace :import do
  desc 'Import cities'
  task :cities => :environment do
    city_importer = CityImporter.new
    city_importer.import!
  end
end
