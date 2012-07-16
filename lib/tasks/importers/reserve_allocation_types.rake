namespace :import do
  desc 'Import reserve allocation types'
  task :reserve_allocation_types => :environment do
    importer = ReserveAllocationTypeImporter.new
    importer.import!
  end
end
