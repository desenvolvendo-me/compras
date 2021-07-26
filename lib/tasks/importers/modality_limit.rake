require 'importer_helper'

namespace :import do
  desc 'Import modality limits'
  task :modality_limits => :environment do
    ImporterHelper.run do
      importer = ModalityLimitImporter.new
      importer.import!
    end
  end
end
