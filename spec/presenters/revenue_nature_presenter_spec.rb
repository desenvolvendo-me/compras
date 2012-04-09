require 'presenter_helper'
require 'app/presenters/revenue_nature_presenter'

describe RevenueNaturePresenter do
  subject do
    described_class.new(revenue_nature, nil, helpers)
  end

  let :date do
    Date.new(2012, 4, 9)
  end

  let :revenue_nature do
    double(:publication_date => date)
  end

  let :helpers do
    double.tap do |helpers|
      helpers.stub(:l).with(date).and_return('09/04/2012')
    end
  end

  it 'should return formatted publication_date' do
    subject.publication_date.should eq '09/04/2012'
  end

  it 'should return nil when have not publication_date' do
    revenue_nature.stub(:publication_date).and_return(nil)
    subject.publication_date.should eq nil
  end
end
