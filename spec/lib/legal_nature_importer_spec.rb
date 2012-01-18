# encoding: utf-8
require 'unit_helper'
require 'lib/importer'
require 'lib/legal_nature_importer'
require 'active_support/core_ext/object/try'

describe LegalNatureImporter do
  subject do
    LegalNatureImporter.new(null_storage)
  end

  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |block|
      block.call
    end

    storage.stub(:find_by_code)

    storage
  end

  it 'imports legal natures' do
    null_storage.stub(:find_by_code).with('200').and_return(double(:id => 200))
    null_storage.stub(:find_by_code).with('500').and_return(double(:id => 500))

    null_storage.should_receive(:create!).with('code' => '100', 'name' => 'Administração Pública', 'parent_id' => nil)
    null_storage.should_receive(:create!).with('code' => '2160', 'name' => 'Grupo de Sociedades', 'parent_id' => 200)
    null_storage.should_receive(:create!).with('code' => '5037', 'name' => 'Outras Instituições Extraterritoriais', 'parent_id' => 500)

    subject.import!
  end
end
