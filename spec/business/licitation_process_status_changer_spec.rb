require 'spec_helper'

describe LicitationProcessStatusChanger do
  let(:licitation_process) { double(:licitation_process) }

  subject do
    described_class.new(licitation_process)
  end

  describe '#in_progress!' do
    context 'when not in progress' do
      before do
        licitation_process.stub(:in_progress? => false)
      end

      it "should update status to 'in_progress'" do
        licitation_process.should_receive(:update_status).with(LicitationProcessStatus::IN_PROGRESS)

        subject.in_progress!
      end
    end

    context 'when in progress' do
      before do
        licitation_process.stub(:in_progress? => true)
      end

      it "should do nothing" do
        licitation_process.should_not_receive(:update_status).with(LicitationProcessStatus::IN_PROGRESS)

        subject.in_progress!
      end
    end
  end
end
