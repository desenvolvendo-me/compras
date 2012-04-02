# encoding: utf-8
require 'presenter_helper'
require 'app/presenters/extra_credit_presenter'

describe ExtraCreditPresenter do
  subject do
    described_class.new(extra_credit, nil, helpers)
  end

  let :date do
    Date.new(2012, 3, 23)
  end

  let :extra_credit do
    double(:publication_date => date)
  end

  let :helpers do
    double.tap do |helpers|
      helpers.stub(:l).with(date).and_return('01/12/2012')
    end
  end

  it 'should return formatted publication_date' do
    subject.publication_date.should eq '01/12/2012'
  end

  it 'should return nil when have not publication_date' do
    extra_credit.stub(:publication_date).and_return(nil)
    subject.publication_date.should eq nil
  end
end
