require 'importer_helper'

namespace :import do
  desc 'Import judgment forms'
  task :judgment_forms => :environment do
    ImporterHelper.run do
      importer = JudgmentFormImporter.new
      importer.import!
    end
  end
end
