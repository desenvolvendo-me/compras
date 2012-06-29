# encoding: utf-8
require 'model_helper'
require 'app/models/occurrence_contractual_historic'

describe OccurrenceContractualHistoric do
  it { should belong_to :contract }

  it { should validate_presence_of :occurrence_date }
  it { should validate_presence_of :observations }
  it { should validate_presence_of :occurrence_contractual_historic_type }
  it { should validate_presence_of :occurrence_contractual_historic_change }

  it 'should return sequence as to_s method' do
    subject.sequence = 1
    subject.to_s.should eq '1'
  end

  describe '#next_code' do
    context 'when the code of last object is 3' do
      before do
        subject.stub(:last_code).and_return(3)
      end

      it 'should be 4' do
        subject.next_code.should eq 4
      end
    end
  end

  describe 'generate the code' do
    before do
      subject.stub(:last_code).and_return 1
    end

    it 'assigns the next_code' do
      subject.run_callbacks(:create)
      subject.sequence.should eq 2
    end
  end
end
