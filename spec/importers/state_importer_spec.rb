require 'importer_helper'
require 'app/importers/state_importer'

describe StateImporter do
  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  subject do
    StateImporter.new(null_repository)
  end

  it 'imports states' do
    null_repository.should_receive(:create!).with('id' => '11', 'name' => 'RONDONIA', 'acronym' => 'RO', 'country_id' => '1')
    null_repository.should_receive(:create!).with('id' => '42', 'name' => 'SANTA CATARINA', 'acronym' => 'SC', 'country_id' => '1')
    null_repository.should_receive(:create!).with('id' => '54', 'name' => 'ESTRANGEIRA', 'acronym' => 'ET', 'country_id' => '1')

    subject.import!
  end
end
