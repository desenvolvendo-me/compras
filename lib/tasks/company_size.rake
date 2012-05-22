namespace :import do
  desc 'Import company sizes'
  task :company_size => :environment do
    company_size_importer = CompanySizeImporter.new
    company_size_importer.import!
  end
end

