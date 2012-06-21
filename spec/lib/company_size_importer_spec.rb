require 'unit_helper'
require 'lib/importer'
require 'lib/company_size_importer'

describe CompanySizeImporter do
  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |&block|
      block.call
    end

    storage
  end

  subject do
    CompanySizeImporter.new(null_storage)
  end

  it 'import company sizes' do
    null_storage.should_receive(:create!).with('name' => 'Empresa de pequeno porte', 'acronym' => 'EPP', 'number' => '3')
    null_storage.should_receive(:create!).with('name' => 'Empresa de grande porte', 'acronym' => 'EGP', 'number' => '5')

    subject.import!
  end
end
