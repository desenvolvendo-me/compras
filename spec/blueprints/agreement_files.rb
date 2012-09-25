AgreementFile.blueprint(:primeiro_arquivo) do
  name { 'Primeiro arquivo' }
  file { File.open("#{Rails.root}/spec/fixtures/example_document.txt") }
end
