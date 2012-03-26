# encoding: utf-8
require 'presenter_helper'
require 'app/presenters/additional_credit_opening_presenter'

describe AdditionalCreditOpeningPresenter do
  subject do
    described_class.new(additional_credit_opening, nil, helpers)
  end

  let :date do
    Date.new(2012, 3, 23)
  end

  let :additional_credit_opening do
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
    additional_credit_opening.stub(:publication_date).and_return(nil)
    subject.publication_date.should eq nil
  end
end
