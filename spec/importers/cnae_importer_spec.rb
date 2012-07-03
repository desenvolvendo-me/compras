# encoding: utf-8
require 'importer_helper'
require 'app/importers/cnae_importer'
require 'active_support/core_ext/object/try'

describe CnaeImporter do
  subject do
    CnaeImporter.new(null_storage)
  end

  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |&block|
      block.call
    end

    storage.stub(:find_by_code)

    storage
  end

  it 'imports CNAEs' do
    null_storage.stub(:find_by_code).with('A').and_return(double(:id => 2))
    null_storage.stub(:find_by_code).with('45.1').and_return(double(:id => 1191))
    null_storage.stub(:find_by_code).with('99.00-8').and_return(double(:id => 2384))

    null_storage.should_receive(:create!).with('code' => '01', 'name' => 'AGRICULTURA, PECUÁRIA E SERVIÇOS RELACIONADOS', 'parent_id' => 2)
    null_storage.should_receive(:create!).with('code' => '45.11-1', 'name' => 'Comércio a varejo e por atacado de veículos automotores', 'parent_id' => 1191)
    null_storage.should_receive(:create!).with('code' => '9900-8/00', 'name' => 'Organismos internacionais e outras instituições extraterritoriais', 'parent_id' => 2384)

    subject.import!
  end
end
