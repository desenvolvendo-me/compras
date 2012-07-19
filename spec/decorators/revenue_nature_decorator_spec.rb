require 'decorator_helper'
require 'app/decorators/revenue_nature_decorator'

describe RevenueNatureDecorator do
  context '#publication_date' do
    before do
      component.stub(:publication_date).and_return(date)
      helpers.stub(:l).with(date).and_return('09/04/2012')
    end

    let :date do
      Date.new(2012, 4, 9)
    end

    it 'should localize' do
      subject.publication_date.should eq '09/04/2012'
    end
  end
end
