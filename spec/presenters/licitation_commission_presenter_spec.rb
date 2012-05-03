require 'presenter_helper'
require 'app/presenters/licitation_commission_presenter'

describe LicitationCommissionPresenter do
  subject do
    described_class.new(licitation_commission, nil, helpers)
  end

  let :licitation_commission do
    double(:regulatory_act_publication_date => Date.new(2012, 2, 16))
  end

  let :helpers do
    double 'helpers'
  end

  it 'should return formatted regulatory_act_publication_date' do
    helpers.stub(:l).with(Date.new(2012, 2, 16)).and_return('16/02/2012')

    subject.regulatory_act_publication_date.should eq '16/02/2012'
  end
end
