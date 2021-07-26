require 'importer_helper'

namespace :import do
  desc 'Import material classes'
  task :material_classes => :environment do
    ImporterHelper.run do
      importer = MaterialClassImporter.new
      importer.import!
    end
  end
end
