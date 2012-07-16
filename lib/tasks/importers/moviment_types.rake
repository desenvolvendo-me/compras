namespace :import do
  desc 'Import moviment types'
  task :moviment_types => :environment do
    importer = MovimentTypeImporter.new
    importer.import!
  end
end
