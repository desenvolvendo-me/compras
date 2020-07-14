require 'simplecov'

SimpleCov.start 'rails' do
  add_filter do |source_file|
    source_file.lines.count < 10
  end

  # 1-Alta
  add_group "Models", "app/models"
  add_group "Features", "app/features"
  add_group "Businesses", "app/business"
  # 2-Média
  add_group "Controllers", "app/controllers"
  add_group "Controllers", "app/api"
  add_group "Libs", "app/lib"
  add_group "Helpers", "app/helpers"
  add_group "Integration", "app/integration"
  # 3-Baixa
  add_group "Importers", "app/importers"
  add_group "Decorators", "app/decorators"
  add_group "Enumerations", "app/enumerations"
  add_group "Exporters", "app/exporters"
  add_group "Searches", "app/searches"
  add_group "Validators", "app/validators"
  add_group "Workers", "app/workers"
  add_group "Reports", "app/reports"
  add_group "Mailers", "app/mailers"
end