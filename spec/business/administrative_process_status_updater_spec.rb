require 'unit_helper'
require 'app/business/administrative_process_status_updater'

describe AdministrativeProcessStatusUpdater do
  subject do
    described_class.new(administrative_process, administrative_process_status)
  end

  let :administrative_process do
    double(:administrative_process)
  end

  let :administrative_process_status do
    double(:status)
  end

  describe '#release!' do
    it 'should change the status of administrative_process to released' do
      administrative_process.should_receive(:update_status).with('released')
      administrative_process_status.should_receive(:value_for).with(:RELEASED).and_return('released')

      subject.release!
    end
  end
end

