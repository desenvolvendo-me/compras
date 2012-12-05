# encoding: utf-8
require 'spec_helper'

describe PriceCollectionsHelper do
  before do
    helper.stub(:resource).and_return(resource)
  end

  let :resource do
    double('PriceCollection')
  end

  context '#proposals_link' do
    let(:decorator) { double(:decorator) }

    before do
      resource.stub(:decorator).and_return(decorator)
    end

    context 'when not persisted' do
      before do
        resource.stub(:persisted?).and_return false
      end

      it 'should be nil' do
        expect(helper.proposals_link).to be_nil
      end
    end

    context 'when persisted' do
      before do
        resource.stub(:persisted?).and_return true
        helper.should_receive(:price_collection_price_collection_proposals_path).
          with(resource).and_return 'path'
      end

      it 'should return the link' do
        decorator.stub(:proposals_not_allowed_message).and_return(nil)
        expect(helper.proposals_link).to eq '<a href="path" class="button primary">Propostas</a>'
      end

      it 'should return the link disabled' do
        decorator.stub(:proposals_not_allowed_message).and_return("mensagem")
        expect(helper.proposals_link).to eq '<a href="path" class="button primary" data-disabled="mensagem">Propostas</a>'
      end
    end
  end

  context '#count_link' do
    context 'when not persisted' do
      before do
        resource.stub(:persisted?).and_return false
      end

      it 'should be nil' do
        expect(helper.count_link).to be_nil
      end
    end

    context 'when persisted' do
      before do
        resource.stub(:persisted?).and_return true
      end

      it 'should return the link' do
        helper.should_receive(:price_collection_path).
          with(resource).and_return 'path'
        expect(helper.count_link).to eq '<a href="path" class="button primary">Relatório</a>'
      end
    end
  end
end
