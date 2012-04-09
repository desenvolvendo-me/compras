# encoding: utf-8
require 'unit_helper'
require 'lib/importer'
require 'lib/revenue_source_importer'
require 'active_support/core_ext/object/try'

describe RevenueSourceImporter do
  subject do
    described_class.new(null_storage, subcategory_storage, category_storage)
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

  let :subcategory_storage do
    double
  end

  it 'imports revenue subcategories' do
    category_storage.stub(:find_by_code).and_return(double(:id => 1))

    subcategory_storage.stub(:find_by_code_and_revenue_category_id).and_return(double(:id => 1))

    null_storage.should_receive(:create!).with('code' => '1', 'description' => 'IMPOSTOS', 'revenue_subcategory_id' => 1)

    subject.import!
  end
end
