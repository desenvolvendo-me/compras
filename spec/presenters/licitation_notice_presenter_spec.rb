require 'presenter_helper'
require 'app/presenters/licitation_notice_presenter'

describe LicitationNoticePresenter do
  subject do
    described_class.new(licitation_notice, nil, helpers)
  end

  let :licitation_notice do
    double(:licitation_notice,
           :licitation_process_process_date => Date.new(2012, 12, 1))
  end

  let :helpers do
    double.tap do |helpers|
      helpers.stub(:l).with(licitation_notice.licitation_process_process_date).
                       and_return('01/12/2012')
    end
  end

  it 'should return localized licitation_notice process_date' do
    subject.licitation_process_process_date.should eq '01/12/2012'
  end
end
