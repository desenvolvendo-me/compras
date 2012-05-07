require 'decorator_helper'
require 'app/decorators/revenue_nature_decorator'

describe RevenueNatureDecorator do
  let :date do
    Date.new(2012, 4, 9)
  end

  it 'should return formatted publication_date' do
    component.stub(:publication_date).and_return(date)
    helpers.stub(:l).with(date).and_return('09/04/2012')

    subject.publication_date.should eq '09/04/2012'
  end

  it 'should return nil when have not publication_date' do
    component.stub(:publication_date).and_return(nil)
    subject.publication_date.should eq nil
  end
end
