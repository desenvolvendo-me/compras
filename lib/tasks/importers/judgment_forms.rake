require 'importer_helper'

namespace :import do
  desc 'Import judgment forms'
  task :judgment_forms => :environment do
    ImporterHelper.run do
      unless JudgmentForm.any?
        puts "Importing judgment forms"

        JudgmentForm.pg_copy_from Rails.root.join('lib/import/files/judgment_forms.csv').to_s

        puts "Done"
      end
    end
  end
end
