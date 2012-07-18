# encoding: utf-8
require 'importer_helper'
require 'app/importers/revenue_category_importer'
require 'active_support/core_ext/object/try'

describe RevenueCategoryImporter do
  subject do
    described_class.new(null_repository)
  end

  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  it 'imports revenue categories' do
    null_repository.should_receive(:create!).with('code' => '1', 'description' => 'RECEITAS CORRENTES')
    null_repository.should_receive(:create!).with('code' => '7', 'description' => 'RECEITAS CORRENTES - INTRA-ORÇAMENTÁRIAS')
    null_repository.should_receive(:create!).with('code' => '8', 'description' => 'RECEITAS DE CAPITAL - INTRA-ORÇAMENTÁRIAS')

    subject.import!
  end
end
