namespace :import do
  desc 'Import legal natures'
  task :legal_natures => :environment do
    Import::LegalNatures.new
  end
end
