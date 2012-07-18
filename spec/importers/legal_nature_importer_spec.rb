# encoding: utf-8
require 'importer_helper'
require 'app/importers/legal_nature_importer'
require 'active_support/core_ext/object/try'

describe LegalNatureImporter do
  subject do
    LegalNatureImporter.new(null_repository)
  end

  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository.stub(:find_by_code)

    repository
  end

  it 'imports legal natures' do
    null_repository.stub(:find_by_code).with('200').and_return(double(:id => 200))
    null_repository.stub(:find_by_code).with('500').and_return(double(:id => 500))

    null_repository.should_receive(:create!).with('code' => '100', 'name' => 'Administração Pública', 'parent_id' => nil)
    null_repository.should_receive(:create!).with('code' => '2160', 'name' => 'Grupo de Sociedades', 'parent_id' => 200)
    null_repository.should_receive(:create!).with('code' => '5037', 'name' => 'Outras Instituições Extraterritoriais', 'parent_id' => 500)

    subject.import!
  end
end
