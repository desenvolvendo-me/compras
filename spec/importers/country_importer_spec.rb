require 'importer_helper'
require 'app/importers/country_importer'

describe CountryImporter do
  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |&block|
      block.call
    end

    storage
  end

  subject do
    CountryImporter.new(null_storage)
  end

  it 'imports countries' do
    null_storage.should_receive(:create!).with('id' => '10', 'name' => 'BRASIL')
    null_storage.should_receive(:create!).with('id' => '275', 'name' => 'SINGAPURA')
    null_storage.should_receive(:create!).with('id' => '348', 'name' => 'RUSSIA')

    subject.import!
  end
end
