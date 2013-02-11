# encoding: utf-8
require 'decorator_helper'
require 'active_support/core_ext/array/grouping'
require 'app/decorators/administrative_process_decorator'

describe AdministrativeProcessDecorator do
  context '#value_estimated' do
    context 'when do not have value_estimated' do
      before do
        subject.stub(:value_estimated).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.value_estimated).to be_nil
      end
    end

    context 'when have value_estimated' do
      before do
        component.stub(:value_estimated).and_return(500)
      end

      it 'should applies currency' do
        expect(subject.value_estimated).to eq 'R$ 500,00'
      end
    end
  end

  context '#total_allocations_value' do
    context 'when do not have total_allocations_value' do
      before do
        component.stub(:total_allocations_value).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.total_allocations_value).to be_nil
      end
    end

    context 'when have total_allocations_value' do
      before do
        component.stub(:total_allocations_value).and_return(400)
      end

      it 'should applies precision' do
        expect(subject.total_allocations_value).to eq '400,00'
      end
    end
  end

  context '#date' do
    context 'when do not have date' do
      before do
        component.stub(:date).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.date).to eq nil
      end
    end

    context 'when have date' do
      before do
        component.stub(:date).and_return(Date.new(2012, 12, 31))
      end

      it 'should localize' do
        expect(subject.date).to eq '31/12/2012'
      end
    end
  end

  context '#not_released_message' do
    it 'when is not released' do
      I18n.backend.store_translations 'pt-BR', :administrative_process => {
          :messages => {
            :not_released => 'não liberado'
        }
      }

      component.stub(:released? => false)

      expect(subject.not_released_message).to eq 'não liberado'
    end

    it 'when released' do
      component.stub(:released? => true)

      expect(subject.not_released_message).to be_nil
    end
  end

  context '#cant_build_licitation_process' do
    it 'when is not allowed and not released' do
      I18n.backend.store_translations 'pt-BR', :administrative_process => {
          :messages => {
            :licitation_process_not_allowed => 'não permitido'
        }
      }

      component.stub(:released? => false, :allow_licitation_process? => false)

      expect(subject.cant_build_licitation_process_message).to eq 'não permitido'
    end

    it 'when is not allowed and not released' do
      I18n.backend.store_translations 'pt-BR', :administrative_process => {
          :messages => {
            :licitation_process_not_allowed => 'não permitido'
        }
      }

      component.stub(:released? => true, :allow_licitation_process? => false)

      expect(subject.cant_build_licitation_process_message).to eq 'não permitido'
    end

    it 'when is allowed and not released' do
      I18n.backend.store_translations 'pt-BR', :administrative_process => {
          :messages => {
            :not_released => 'não liberado'
        }
      }

      component.stub(:released? => false, :allow_licitation_process? => true)

      expect(subject.cant_build_licitation_process_message).to eq 'não liberado'
    end

    it 'when is allowed and released' do
      component.stub(:released? => true, :allow_licitation_process? => true)

      expect(subject.cant_build_licitation_process_message).to be_nil
    end
  end

  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have name and creditable_type' do
      expect(described_class.header_attributes).to include :code_and_year
      expect(described_class.header_attributes).to include :date
      expect(described_class.header_attributes).to include :object_type
      expect(described_class.header_attributes).to include :summarized_object
    end
  end

  describe "#code_and_year" do
    before { component.stub(:process => 1, :year => 2012) }

    it "should return code/year" do
      expect(subject.code_and_year).to eq "1/2012"
    end
  end

  describe '#judgment_forms_available' do
    let(:judgment_form) { double(:judgment_form, :to_s => 'judgment_form') }
    let(:judgment_form_repository) { double(:judgment_form_repository) }

    context 'when there is a judgment_form selected' do
      before do
        component.stub(:judgment_form => judgment_form)
      end

      context 'when judgment_form selected is disabled' do
        before do
          judgment_form.stub(:enabled => false)
        end

        it 'should return all available and the selected' do
          judgment_form_repository.stub(:enabled => ['available1', 'available2'])

          expect(subject.judgment_forms_available(judgment_form_repository)).to eq ['available1', 'available2', judgment_form]
        end
      end

      context 'when judgment_form selected is enabled' do
        before do
          judgment_form.stub(:enabled => true)
        end

        it 'should return all available' do
          judgment_form_repository.stub(:enabled => ['available1', 'available2', judgment_form])

          expect(subject.judgment_forms_available(judgment_form_repository)).to eq ['available1', 'available2', judgment_form]
        end
      end

      context 'when there is no judgment_form' do
        it 'should return all available' do
          judgment_form_repository.stub(:enabled => ['available1', 'available2', judgment_form])

          expect(subject.judgment_forms_available(judgment_form_repository)).to eq ['available1', 'available2', judgment_form]
        end
      end
    end
  end

  describe '#subtitle' do
    it 'should returns the subtitle based at code and year' do
      subject.stub(:code_and_year => '1/2013')

      expect(subject.subtitle).to eq '1/2013'
    end
  end
end
