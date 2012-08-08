# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_process_bidder_proposal_decorator'

describe LicitationProcessBidderProposalDecorator do
  context '#unit_price' do
    context 'when do not have unit_price' do
      before do
        component.stub(:unit_price).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.unit_price).to be_nil
      end
    end

    context 'when have unit_price' do
      before do
        component.stub(:unit_price).and_return(5000.0)
      end

      it 'should applies precision' do
        expect(subject.unit_price).to eq '5.000,00'
      end
    end
  end

  context '#total_price' do
    context 'when do not have total_price' do
      before do
        component.stub(:total_price).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.total_price).to be_nil
      end
    end

    context 'when have total_price' do
      before do
        component.stub(:total_price).and_return(5000.0)
      end

      it 'should applies precision' do
        expect(subject.total_price).to eq '5.000,00'
      end
    end
  end

  context '#id_or_mustache_variable' do
    it 'should return mustache variable' do
      component.should_receive(:id).and_return(nil)
      expect(subject.id_or_mustache_variable).to eq "{{id}}"
    end

    it 'should return id' do
      component.should_receive(:id).and_return(1)
      expect(subject.id_or_mustache_variable).to eq 1
    end
  end

  context '#code_or_mustache_variable' do
    it 'should return mustache variable' do
      component.should_receive(:code).and_return(nil)
      expect(subject.code_or_mustache_variable).to eq "{{code}}"
    end

    it 'should return code' do
      component.should_receive(:code).and_return(1)
      expect(subject.code_or_mustache_variable).to eq 1
    end
  end

  context '#reference_unit_or_mustache_variable' do
    it 'should return mustache variable' do
      component.should_receive(:reference_unit).and_return(nil)
      expect(subject.reference_unit_or_mustache_variable).to eq "{{reference_unit}}"
    end

    it 'should return reference_unit' do
      component.should_receive(:reference_unit).and_return('m')
      expect(subject.reference_unit_or_mustache_variable).to eq 'm'
    end
  end

  context '#description_or_mustache_variable' do
    it 'should return mustache variable' do
      component.should_receive(:description).and_return(nil)
      expect(subject.description_or_mustache_variable).to eq "{{description}}"
    end

    it 'should return description' do
      component.should_receive(:description).and_return('macbook')
      expect(subject.description_or_mustache_variable).to eq 'macbook'
    end
  end

  context '#quantity_or_mustache_variable' do
    it 'should return mustache variable' do
      component.should_receive(:quantity).and_return(nil)
      expect(subject.quantity_or_mustache_variable).to eq "{{quantity}}"
    end

    it 'should return quantity' do
      component.should_receive(:quantity).and_return(1)
      expect(subject.quantity_or_mustache_variable).to eq 1
    end
  end

  context '#unit_price_or_mustache_variable' do
    it 'should return mustache variable' do
      component.should_receive(:unit_price).and_return(nil)
      expect(subject.unit_price_or_mustache_variable).to eq "{{unit_price}}"
    end

    it 'should return unit_price' do
      subject.should_receive(:unit_price).and_return(10)
      expect(subject.unit_price_or_mustache_variable).to eq 10
    end
  end

  context '#total_price_or_mustache_variable' do
    it 'should return mustache variable' do
      component.should_receive(:total_price).and_return(nil)
      expect(subject.total_price_or_mustache_variable).to eq "{{total_price}}"
    end

    it 'should return total_price' do
      subject.should_receive(:total_price).and_return(20)
      expect(subject.total_price_or_mustache_variable).to eq 20
    end
  end
end
