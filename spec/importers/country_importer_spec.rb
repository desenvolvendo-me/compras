require 'importer_helper'
require 'app/importers/country_importer'

describe CountryImporter do
  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  subject do
    CountryImporter.new(null_repository)
  end

  it 'imports countries' do
    null_repository.should_receive(:create!).with('id' => '10', 'name' => 'BRASIL')
    null_repository.should_receive(:create!).with('id' => '275', 'name' => 'SINGAPURA')
    null_repository.should_receive(:create!).with('id' => '348', 'name' => 'RUSSIA')

    subject.import!
  end
end
