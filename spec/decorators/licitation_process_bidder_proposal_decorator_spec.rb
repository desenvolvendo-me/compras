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
        subject.unit_price.should be_nil
      end
    end

    context 'when have unit_price' do
      before do
        component.stub(:unit_price).and_return(5000.0)
      end

      it 'should applies precision' do
        subject.unit_price.should eq '5.000,00'
      end
    end
  end

  context '#total_price' do
    context 'when do not have total_price' do
      before do
        component.stub(:total_price).and_return(nil)
      end

      it 'should be nil' do
        subject.total_price.should be_nil
      end
    end

    context 'when have total_price' do
      before do
        component.stub(:total_price).and_return(5000.0)
      end

      it 'should applies precision' do
        subject.total_price.should eq '5.000,00'
      end
    end
  end

  context '#id_or_mustache_variable' do
    it 'should return mustache variable' do
      component.should_receive(:id).and_return(nil)
      subject.id_or_mustache_variable.should eq "{{id}}"
    end

    it 'should return id' do
      component.should_receive(:id).and_return(1)
      subject.id_or_mustache_variable.should eq 1
    end
  end

  context '#code_or_mustache_variable' do
    it 'should return mustache variable' do
      component.should_receive(:code).and_return(nil)
      subject.code_or_mustache_variable.should eq "{{code}}"
    end

    it 'should return code' do
      component.should_receive(:code).and_return(1)
      subject.code_or_mustache_variable.should eq 1
    end
  end

  context '#reference_unit_or_mustache_variable' do
    it 'should return mustache variable' do
      component.should_receive(:reference_unit).and_return(nil)
      subject.reference_unit_or_mustache_variable.should eq "{{reference_unit}}"
    end

    it 'should return reference_unit' do
      component.should_receive(:reference_unit).and_return('m')
      subject.reference_unit_or_mustache_variable.should eq 'm'
    end
  end

  context '#description_or_mustache_variable' do
    it 'should return mustache variable' do
      component.should_receive(:description).and_return(nil)
      subject.description_or_mustache_variable.should eq "{{description}}"
    end

    it 'should return description' do
      component.should_receive(:description).and_return('macbook')
      subject.description_or_mustache_variable.should eq 'macbook'
    end
  end

  context '#quantity_or_mustache_variable' do
    it 'should return mustache variable' do
      component.should_receive(:quantity).and_return(nil)
      subject.quantity_or_mustache_variable.should eq "{{quantity}}"
    end

    it 'should return quantity' do
      component.should_receive(:quantity).and_return(1)
      subject.quantity_or_mustache_variable.should eq 1
    end
  end

  context '#unit_price_or_mustache_variable' do
    it 'should return mustache variable' do
      component.should_receive(:unit_price).and_return(nil)
      subject.unit_price_or_mustache_variable.should eq "{{unit_price}}"
    end

    it 'should return unit_price' do
      subject.should_receive(:unit_price).and_return(10)
      subject.unit_price_or_mustache_variable.should eq 10
    end
  end

  context '#total_price_or_mustache_variable' do
    it 'should return mustache variable' do
      component.should_receive(:total_price).and_return(nil)
      subject.total_price_or_mustache_variable.should eq "{{total_price}}"
    end

    it 'should return total_price' do
      subject.should_receive(:total_price).and_return(20)
      subject.total_price_or_mustache_variable.should eq 20
    end
  end
end
