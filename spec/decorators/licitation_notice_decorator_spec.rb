require 'decorator_helper'
require 'app/decorators/licitation_notice_decorator'

describe LicitationNoticeDecorator do
  context '#licitation_process_process_date' do
    context 'when do not have licitation_process_process_date' do
      before do
        component.stub(:licitation_process_process_date).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.licitation_process_process_date).to be_nil
      end
    end

    context 'when have licitation_process_process_date' do
      before do
        component.stub(:licitation_process_process_date).and_return(Date.new(2012, 12, 13))
      end

      it 'should localized' do
        expect(subject.licitation_process_process_date).to eq '13/12/2012'
      end
    end
  end
end
