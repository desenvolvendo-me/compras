#encoding: utf-8
require 'importer_helper'

namespace :import do
  desc 'Import customizations'
  task :customizations => :environment do
    unless uf = ENV['UF']
      raise ArgumentError, 'Argumento de UF não fornecido. Utilizar conforme exemplo: rake import:customizations UF=SP'
    end

    ImporterHelper.run do
      customization_importer = CustomizationImporter.new
      customization_importer.import!(uf)
    end
  end
end
