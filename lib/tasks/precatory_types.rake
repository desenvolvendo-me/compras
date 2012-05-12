namespace :import do
  desc 'Import precatory types'
  task :precatory_types => :environment do
    precatory_types_importer = PrecatoryTypeImporter.new
    precatory_types_importer.import!
  end
end
