require 'importer_helper'

namespace :import do
  desc 'Import cnaes'
  task :cnaes => :environment do
    ImporterHelper.run do
      cnae_importer = CnaeImporter.new
      cnae_importer.import!
    end
  end
end
