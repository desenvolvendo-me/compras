# encoding: utf-8
require 'importer_helper'
require 'app/importers/revenue_category_importer'

describe RevenueCategoryImporter do
  subject do
    RevenueCategoryImporter.new(null_repository)
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
    null_repository.should_receive(:create!).with('code' => '2', 'description' => 'RECEITAS DE CAPITAL')
    null_repository.should_receive(:create!).with('code' => '8', 'description' => 'RECEITAS DE CAPITAL - INTRA-ORÇAMENTÁRIAS')

    subject.import!
  end
end
