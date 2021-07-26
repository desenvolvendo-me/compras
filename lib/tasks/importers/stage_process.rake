require 'importer_helper'

namespace :import do
  desc 'Import stage process'
  task :stage_process => :environment do
    ImporterHelper.run do
      unless StageProcess.any?
        puts "Importing stage process"

        StageProcess.pg_copy_from Rails.root.join('lib/import/files/stage_processes.csv').to_s

        puts "Done"
      end
    end
  end
end
