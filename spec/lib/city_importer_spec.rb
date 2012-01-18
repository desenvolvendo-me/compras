require 'unit_helper'
require 'lib/importer'
require 'lib/city_importer'

describe CityImporter do
  subject do
    CityImporter.new(null_storage)
  end

  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |block|
      block.call
    end

    storage
  end

  it 'imports cities' do
    null_storage.should_receive(:create!).with('id' => '1', 'name' => "ALTA FLORESTA D'OESTE", 'code' => '1100015', 'state_id' => '1')
    null_storage.should_receive(:create!).with('id' => '2798', 'name' => 'PASSABEM', 'code' => '3147501', 'state_id' => '17')
    null_storage.should_receive(:create!).with('id' => '5598', 'name' => 'ESTRANGEIRA', 'code' => nil, 'state_id' => '28')

    subject.import!
  end
end
