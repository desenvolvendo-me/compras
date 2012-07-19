# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/price_collection_classification_decorator'

describe PriceCollectionClassificationDecorator do
  context '#unit_price_by_proposal' do
    before do
      component.stub(:unit_price_by_proposal).and_return(500.0)
      helpers.should_receive(:number_with_precision).with(500.0).and_return("500,00")
    end

    it 'should applies currency' do
      subject.unit_price_by_proposal(nil).should eq '500,00'
    end
  end

  context '#total_value_by_proposal' do
    before do
      component.stub(:total_value_by_proposal).and_return(780.0)
      helpers.should_receive(:number_with_precision).with(780.0).and_return("780,00")
    end

    it 'should applies currency' do
      subject.total_value_by_proposal(nil).should eq '780,00'
    end
  end

  context '#unit_price_by_price_collection_and_creditor' do
    before do
      component.stub(:unit_price_by_price_collection_and_creditor).and_return(330.0)
      helpers.should_receive(:number_with_precision).with(330.0).and_return("330,00")
    end

    it 'should applies currency' do
      subject.unit_price_by_price_collection_and_creditor(nil, nil).should eq '330,00'
    end
  end

  context '#total_value_by_price_collection_and_creditor' do
    before do
      component.stub(:total_value_by_price_collection_and_creditor).and_return(220.0)
      helpers.should_receive(:number_with_precision).with(220.0).and_return("220,00")
    end

    it 'should applies precision' do
      subject.total_value_by_price_collection_and_creditor(nil, nil).should eq '220,00'
    end
  end
end
