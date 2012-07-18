require 'importer_helper'
require 'app/importers/company_size_importer'

describe CompanySizeImporter do
  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  subject do
    CompanySizeImporter.new(null_repository)
  end

  it 'import company sizes' do
    null_repository.should_receive(:create!).with('name' => 'Empresa de pequeno porte', 'acronym' => 'EPP', 'number' => '3')
    null_repository.should_receive(:create!).with('name' => 'Empresa de grande porte', 'acronym' => 'EGP', 'number' => '5')

    subject.import!
  end
end
