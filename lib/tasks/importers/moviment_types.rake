require 'importer_helper'

namespace :import do
  desc 'Import moviment types'
  task :moviment_types => :environment do
    ImporterHelper.run do
      importer = MovimentTypeImporter.new
      importer.import!
    end
  end
end
