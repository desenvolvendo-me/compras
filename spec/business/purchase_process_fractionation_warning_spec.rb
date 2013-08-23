require 'unit_helper'
require 'i18n'
require 'active_support/core_ext/array/conversions'
require 'app/business/purchase_process_fractionation_warning'

describe PurchaseProcessFractionationWarning do
  before do
    I18n.default_locale = 'pt-BR'

    I18n.backend.store_translations 'pt-BR',support: {
      array: {
        two_words_connector: ' e '
      }
    }

    I18n.backend.store_translations 'pt-BR', errors: {
      messages: {
        fractionation_warning_message: {
          one: "O material %{materials} está caracterizando possível fracionamento.",
          other: "Os materiais %{materials} estão caracterizando possível fracionamento."
        }
      }
    }
  end

  describe '#message' do
    let(:material1) { double(:material1, material_class_id: 5) }
    let(:material2) { double(:material2, material_class_id: 10) }
    let(:fractionations) { double(:fractionations) }
    let(:repository) { double(:repository) }
    let(:modality_limit_chooser) { double(:modality_limit_chooser) }
    let :purchase_process do
      double(:purchase_process, year: 2013, materials: [material1],
             fractionations: fractionations)
    end

    subject do
      described_class.new(purchase_process, repository: repository, modality_limit_chooser: modality_limit_chooser)
    end

    context "when prefecture's control_fractionation is disabled" do
      before do
        subject.stub(warn_enabled?: false)
      end

      it 'should return nil' do
        expect(subject.message).to be_nil
      end
    end

    context "when prefecture's control_fractionation is enabled" do
      before do
        subject.stub(warn_enabled?: true)
      end

      context 'when there is only one item over limit' do
        it 'should return nil' do
          modality_limit_chooser.
            stub(:limit).
            with(purchase_process).
            and_return(100)

          repository.
            should_receive(:by_year).
            with(2013).
            and_return(repository)

          repository.
            should_receive(:by_material_class_id).
            with(5).
            and_return(repository)

          repository.should_receive(:sum).and_return(101)

          expect(subject.message).to eq "O material #{material1} está caracterizando possível fracionamento."
        end
      end

      context 'when there more than one item over limit' do
        before do
          purchase_process.stub(materials: [material1, material2])
        end

        it 'should return nil' do
          modality_limit_chooser.
            stub(:limit).
            with(purchase_process).
            and_return(100)

          repository.
            stub(:by_year).
            with(2013).
            and_return(repository)

          repository.
            should_receive(:by_material_class_id).
            with(5).
            and_return(repository)

          repository.
            should_receive(:by_material_class_id).
            with(10).
            and_return(repository)

          repository.stub(:sum).and_return(101)

          expect(subject.message).to eq "Os materiais #{material1} e #{material2} estão caracterizando possível fracionamento."
        end
      end
    end
  end
end
