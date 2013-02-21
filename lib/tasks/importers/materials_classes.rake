require 'importer_helper'

namespace :import do
  desc 'Import materials classes'
  task :materials_classes => :environment do
    ImporterHelper.run do
      importer = MaterialsClassImporter.new
      importer.import!
    end
  end
end
