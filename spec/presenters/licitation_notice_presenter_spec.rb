require 'presenter_helper'
require 'app/presenters/licitation_notice_presenter'

describe LicitationNoticePresenter do
  subject do
    described_class.new(licitation_notice, nil, helpers)
  end

  let :licitation_notice do
    double(:licitation_notice, :licitation_process_process_date => date)
  end

  let :date do
    Date.new(2012, 12, 1)
  end

  let :helpers do
    double 'helpers'
  end

  it 'should return localized licitation_notice process_date' do
    helpers.stub(:l).with(date).and_return('01/12/2012')

    subject.licitation_process_process_date.should eq '01/12/2012'
  end
end
