require 'decorator_helper'
require 'app/decorators/licitation_notice_decorator'

describe LicitationNoticeDecorator do
  context '#licitation_process_process_date' do
    before do
      component.stub(:licitation_process_process_date).and_return(date)
      helpers.stub(:l).with(date).and_return('01/12/2012')
    end

    let :date do
      Date.new(2012, 12, 1)
    end

    it 'should localized' do
      subject.licitation_process_process_date.should eq '01/12/2012'
    end
  end
end
