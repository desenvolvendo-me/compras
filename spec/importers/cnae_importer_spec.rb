# encoding: utf-8
require 'importer_helper'
require 'app/importers/cnae_importer'
require 'active_support/core_ext/object/try'

describe CnaeImporter do
  subject do
    CnaeImporter.new(null_repository)
  end

  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository.stub(:find_by_code)

    repository
  end

  it 'imports CNAEs' do
    null_repository.stub(:find_by_code).with('A').and_return(double(:id => 2))
    null_repository.stub(:find_by_code).with('45.1').and_return(double(:id => 1191))
    null_repository.stub(:find_by_code).with('99.00-8').and_return(double(:id => 2384))

    null_repository.should_receive(:create!).with('code' => '01', 'name' => 'AGRICULTURA, PECUÁRIA E SERVIÇOS RELACIONADOS', 'parent_id' => 2)
    null_repository.should_receive(:create!).with('code' => '45.11-1', 'name' => 'Comércio a varejo e por atacado de veículos automotores', 'parent_id' => 1191)
    null_repository.should_receive(:create!).with('code' => '9900-8/00', 'name' => 'Organismos internacionais e outras instituições extraterritoriais', 'parent_id' => 2384)

    subject.import!
  end
end
