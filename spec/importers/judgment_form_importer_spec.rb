# encoding: utf-8
require 'importer_helper'
require 'app/importers/judgment_form_importer'

describe JudgmentFormImporter do
  subject do
    described_class.new(null_repository, :kind_enumeration => kind,
                        :licitation_kind_enumeration => licitation_kind)
  end

  let(:kind) { double(:kind) }
  let(:licitation_kind) { double(:licitation_kind) }

  let :null_repository do
    repository = double.as_null_object

    repository.stub(:transaction) do |&block|
      block.call
    end

    repository
  end

  before do
    kind.stub(:value_for).with('GLOBAL').and_return('global')
    kind.stub(:value_for).with('ITEM').and_return('item')
    kind.stub(:value_for).with('PART').and_return('part')

    licitation_kind.stub(:value_for).with('LOWEST_PRICE').and_return('lowest_price')
    licitation_kind.stub(:value_for).with('BEST_TECHNIQUE').and_return('best_technique')
    licitation_kind.stub(:value_for).with('TECHNICAL_AND_PRICE').and_return('technical_and_price')
    licitation_kind.stub(:value_for).with('BEST_AUCTION_OR_OFFER').and_return('best_auction_or_offer')
  end

  it 'import' do
    null_repository.should_receive(:create!).with('description' => 'Menor Preço - Global', 'kind' => 'global', 'licitation_kind' => 'lowest_price')
    null_repository.should_receive(:create!).with('description' => 'Menor Preço - Por Lote', 'kind' => 'part', 'licitation_kind' => 'lowest_price')
    null_repository.should_receive(:create!).with('description' => 'Menor Preço - Por Item', 'kind' => 'item', 'licitation_kind' => 'lowest_price')
    null_repository.should_receive(:create!).with('description' => 'Melhor Técnica', 'kind' => 'item', 'licitation_kind' => 'best_technique')
    null_repository.should_receive(:create!).with('description' => 'Técnica e Preço', 'kind' => 'item', 'licitation_kind' => 'technical_and_price')
    null_repository.should_receive(:create!).with('description' => 'Maior Lance ou Oferta', 'kind' => 'item', 'licitation_kind' => 'best_auction_or_offer')

    subject.import!
  end
end
