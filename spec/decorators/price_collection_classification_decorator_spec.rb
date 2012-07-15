# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/price_collection_classification_decorator'

describe PriceCollectionClassificationDecorator do
  it 'should return unit value with precision' do
    component.stub(:unit_value).and_return(50.0)
    helpers.should_receive(:number_with_precision).with(50.0).and_return("50,00")

    subject.unit_value.should eq '50,00'
  end

  it 'should return total value with precision' do
    component.stub(:total_value).and_return(80.0)
    helpers.should_receive(:number_with_precision).with(80.0).and_return("80,00")

    subject.total_value.should eq '80,00'
  end

  it 'should return unit price by proposal with precision' do
    component.stub(:unit_price_by_proposal).and_return(500.0)
    helpers.should_receive(:number_with_precision).with(500.0).and_return("500,00")

    subject.unit_price_by_proposal(nil).should eq '500,00'
  end

  it 'should return total value by proposal with precision' do
    component.stub(:total_value_by_proposal).and_return(780.0)
    helpers.should_receive(:number_with_precision).with(780.0).and_return("780,00")

    subject.total_value_by_proposal(nil).should eq '780,00'
  end

  it 'should return unit_price by price collection with precision' do
    component.stub(:unit_price_by_price_collection_and_creditor).and_return(330.0)
    helpers.should_receive(:number_with_precision).with(330.0).and_return("330,00")

    subject.unit_price_by_price_collection_and_creditor(nil, nil).should eq '330,00'
  end

  it 'should return total value by price collection with precision' do
    component.stub(:total_value_by_price_collection_and_creditor).and_return(220.0)
    helpers.should_receive(:number_with_precision).with(220.0).and_return("220,00")

    subject.total_value_by_price_collection_and_creditor(nil, nil).should eq '220,00'
  end
end
