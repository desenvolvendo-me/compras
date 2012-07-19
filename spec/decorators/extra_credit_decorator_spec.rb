# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/extra_credit_decorator'

describe ExtraCreditDecorator do
  context '#publication_date' do
    before do
      component.stub(:publication_date).and_return(date)
      helpers.stub(:l).with(date).and_return('01/12/2012')
    end

    let :date do
      Date.new(2012, 3, 23)
    end

    it 'should localize' do
      subject.publication_date.should eq '01/12/2012'
    end
  end
end
