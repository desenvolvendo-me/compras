namespace :import do
  desc 'Import cnaes'
  task :cnaes => :environment do
    cnae_importer = CnaeImporter.new
    cnae_importer.import!
  end
end
