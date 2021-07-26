require 'spec_helper'

describe LicitationProcessPublicationsHelper do
  describe '#edit_title' do
    let(:resource) { double(:resource, :licitation_process => '1/2013', :to_s => '4') }

    it 'should return the title for edit' do
      helper.stub(:resource => resource)

      expect(helper.edit_title).to eq 'Editar Publicação 4 do Processo de Compra 1/2013'
    end
  end

  describe '#new_title' do
    let(:resource) { double(:resource, :licitation_process => '1/2013') }

    it 'should return the title for new' do
      helper.stub(:singular => 'Publicação')
      helper.stub(:resource => resource)

      expect(helper.new_title).to eq 'Criar Publicação para o Processo de Compra 1/2013'
    end
  end

  describe '#publication_of_collection' do
    let(:licitation_process) { double(:licitation_process) }

    context 'when direct_purchase' do
      before do
        licitation_process.stub(direct_purchase?: true)
      end

      it 'should not show edital' do
        PublicationOf.should_receive(:allowed_for_direct_purchase).and_return('without_edital')

        expect(helper.publication_of_collection(licitation_process)).to eq 'without_edital'
      end
    end

    context 'when not direct_purchase' do
      before do
        licitation_process.stub(direct_purchase?: false)
      end

      it 'should show edital' do
        PublicationOf.should_receive(:to_a).and_return([])

        expect(helper.publication_of_collection(licitation_process)).to eq []
      end
    end
  end
end
