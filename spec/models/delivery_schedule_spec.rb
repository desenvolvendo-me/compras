# encoding: utf-8
require 'model_helper'
require 'app/models/delivery_schedule'

describe DeliverySchedule do
  it { should belong_to :contract }

  describe '#next_code' do
    context 'when the code of last delivery schedule process is 3' do
      before do
        subject.stub(:last_code).and_return(3)
      end

      it 'should be 4' do
        subject.next_code.should eq 4
      end
    end
  end
end
