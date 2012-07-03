# encoding: utf-8
require 'importer_helper'
require 'app/importers/revenue_subcategory_importer'
require 'active_support/core_ext/object/try'

describe RevenueSubcategoryImporter do
  subject do
    RevenueSubcategoryImporter.new(null_storage, category_storage)
  end

  let :null_storage do
    storage = double.as_null_object

    storage.stub(:transaction) do |&block|
      block.call
    end

    storage
  end

  let :category_storage do
    double
  end

  it 'imports revenue subcategories' do
    category_storage.stub(:find_by_code).with('1').and_return(double(:id => 1))
    category_storage.stub(:find_by_code).with('2').and_return(double(:id => 2))
    category_storage.stub(:find_by_code).with('7').and_return(double(:id => 3))
    category_storage.stub(:find_by_code).with('8').and_return(double(:id => 4))
    category_storage.stub(:find_by_code).with('9').and_return(double(:id => 5))

    null_storage.should_receive(:create!).with('code' => '4', 'description' => 'RECEITA AGROPECUÁRIA', 'revenue_category_id' => 1)
    null_storage.should_receive(:create!).with('code' => '5', 'description' => 'RECEITA INDUSTRIAL', 'revenue_category_id' => 1)
    null_storage.should_receive(:create!).with('code' => '5', 'description' => 'RECEITA INDUSTRIAL - INTRA-ORÇAMENTÁRIAS', 'revenue_category_id' => 3)
    null_storage.should_receive(:create!).with('code' => '5', 'description' => 'OUTRAS RECEITAS DE CAPITAL - INTRA-ORÇAMENTÁRIAS', 'revenue_category_id' => 4)

    subject.import!
  end
end
