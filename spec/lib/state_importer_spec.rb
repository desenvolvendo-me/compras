require 'unit_helper'
require 'lib/importer'
require 'lib/state_importer'

describe StateImporter do
  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |block|
      block.call
    end

    storage
  end

  subject do
    StateImporter.new(null_storage)
  end

  it 'imports states' do
    null_storage.should_receive(:create!).with('id' => '11', 'name' => 'RONDONIA', 'acronym' => 'RO', 'country_id' => '1')
    null_storage.should_receive(:create!).with('id' => '42', 'name' => 'SANTA CATARINA', 'acronym' => 'SC', 'country_id' => '1')
    null_storage.should_receive(:create!).with('id' => '54', 'name' => 'ESTRANGEIRA', 'acronym' => 'ET', 'country_id' => '1')

    subject.import!
  end
end
