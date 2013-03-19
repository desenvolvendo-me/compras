# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_process_ratification_item_decorator'

describe LicitationProcessRatificationItemDecorator do
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

  describe '#bidder_proposal_id_or_mustache_variable' do
    context 'when component has a bidder_proposal_id' do
      before do
        component.stub(:bidder_proposal_id => 10)
      end

      it 'should return the bidder_proposal_id' do
        expect(subject.bidder_proposal_id_or_mustache_variable).to eq 10
      end
    end

    context "when component's bidder_proposal_id is nil" do
      before do
        component.stub(:bidder_proposal_id => nil)
      end

      it 'should return the {{bidder_proposal_id}}' do
        expect(subject.bidder_proposal_id_or_mustache_variable).to eq '{{bidder_proposal_id}}'
      end
    end
  end

  describe '#code_or_mustache_variable' do
    context 'when component has a code' do
      before do
        component.stub(:code => 10)
      end

      it 'should return the code' do
        expect(subject.code_or_mustache_variable).to eq 10
      end
    end

    context "when component's code is nil" do
      before do
        component.stub(:code => nil)
      end

      it 'should return the {{code}}' do
        expect(subject.code_or_mustache_variable).to eq '{{code}}'
      end
    end
  end

  describe '#description_or_mustache_variable' do
    context 'when component has a description' do
      before do
        component.stub(:description => 'Antivirus')
      end

      it 'should return the description' do
        expect(subject.description_or_mustache_variable).to eq 'Antivirus'
      end
    end

    context "when component's description is nil" do
      before do
        component.stub(:description => nil)
      end

      it 'should return the {{description}}' do
        expect(subject.description_or_mustache_variable).to eq '{{description}}'
      end
    end
  end

  describe '#reference_unit_or_mustache_variable' do
    context 'when component has a reference_unit' do
      before do
        component.stub(:reference_unit => 10)
      end

      it 'should return the reference_unit' do
        expect(subject.reference_unit_or_mustache_variable).to eq 10
      end
    end

    context "when component's reference_unit is nil" do
      before do
        component.stub(:reference_unit => nil)
      end

      it 'should return the {{reference_unit}}' do
        expect(subject.reference_unit_or_mustache_variable).to eq '{{reference_unit}}'
      end
    end
  end

  describe '#quantity_or_mustache_variable' do
    context 'when component has a quantity' do
      before do
        component.stub(:quantity => 10)
      end

      it 'should return the quantity' do
        expect(subject.quantity_or_mustache_variable).to eq 10
      end
    end

    context "when component's quantity is nil" do
      before do
        component.stub(:quantity => nil)
      end

      it 'should return the {{quantity}}' do
        expect(subject.quantity_or_mustache_variable).to eq '{{quantity}}'
      end
    end
  end

  describe '#total_price_or_mustache_variable' do
    context 'when component has a total_price' do
      before do
        component.stub(:total_price => 10)
      end

      it 'should return the total_price' do
        expect(subject.total_price_or_mustache_variable).to eq '10,00'
      end
    end

    context "when component's total_price is nil" do
      before do
        component.stub(:total_price => nil)
      end

      it 'should return the {{total_price}}' do
        expect(subject.total_price_or_mustache_variable).to eq '{{total_price}}'
      end
    end
  end

  describe '#unit_price_or_mustache_variable' do
    context 'when component has a unit_price' do
      before do
        component.stub(:unit_price => 10)
      end

      it 'should return the unit_price' do
        expect(subject.unit_price_or_mustache_variable).to eq '10,00'
      end
    end

    context "when component's unit_price is nil" do
      before do
        component.stub(:unit_price => nil)
      end

      it 'should return the {{unit_price}}' do
        expect(subject.unit_price_or_mustache_variable).to eq '{{unit_price}}'
      end
    end
  end
end
