require 'importer_helper'
require 'app/importers/city_importer'

describe CityImporter do
  subject do
    CityImporter.new(null_repository)
  end

  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  it 'imports cities' do
    null_repository.should_receive(:create!).with('id' => '1', 'name' => "ALTA FLORESTA D'OESTE", 'code' => '1100015', 'state_id' => '1')
    null_repository.should_receive(:create!).with('id' => '2798', 'name' => 'PASSABEM', 'code' => '3147501', 'state_id' => '17')
    null_repository.should_receive(:create!).with('id' => '5598', 'name' => 'ESTRANGEIRA', 'code' => nil, 'state_id' => '28')

    subject.import!
  end
end
