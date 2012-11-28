# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/purchase_solicitation_item_group_decorator'

describe PurchaseSolicitationItemGroupDecorator do
  context 'when not annulled' do
    before do
      component.stub(:annulled?).and_return(false)
    end

    it 'should allow_submit_button when it is not annulled and is editable' do
      component.stub(:editable?).and_return(true)

      expect(subject).to be_allow_submit_button
    end

    it 'should not allow_submit_button when it is not annulled and is not editable' do
      component.stub(:editable?).and_return(false)

      expect(subject).not_to be_allow_submit_button
    end

    it 'should allow_annul_link if it is annullable' do
      component.stub(:annullable?).and_return(true)

      expect(subject).to be_allow_annul_link
    end

    it 'should not allow_annul_link if it is not annullable' do
      component.stub(:annullable?).and_return(false)

      expect(subject).to_not be_allow_annul_link
    end
  end

  context 'when is annulled' do
    before do
      component.stub(:annulled?).and_return(true)
    end

    it 'should not allow_submit_button when it is annulled and is editable' do
      component.stub(:editable?).and_return(true)

      expect(subject).not_to be_allow_submit_button
    end

    it 'should not allow_submit_button when it is annulled and is not editable' do
      component.stub(:editable?).and_return(false)

      expect(subject).not_to be_allow_submit_button
    end

    it 'should allow_annul_link if it is annullable' do
      component.stub(:annullable?).and_return(true)

      expect(subject).to be_allow_annul_link
    end

    it 'should allow_annul_link if it is not annullable' do
      component.stub(:annullable?).and_return(false)

      expect(subject).to be_allow_annul_link
    end
  end

  context '#not_allow_submit_message' do
    it 'when is annulled' do
      I18n.backend.store_translations 'pt-BR', :purchase_solicitation_item_group => {
          :messages => {
            :not_allow_submit => {
              :annulled => 'não pode'
            }
        }
      }
      component.stub(:annulled? => true)

      expect(subject.not_allow_submit_message).to eq 'não pode'
    end

    it 'when is not annulled nor editable' do
      I18n.backend.store_translations 'pt-BR', :purchase_solicitation_item_group => {
          :messages => {
            :not_allow_submit => {
              :not_editable => 'não pode'
            }
        }
      }

      component.stub(:annulled? => false, :editable? => false)

      expect(subject.not_allow_submit_message).to eq 'não pode'
    end

    it 'when is not annulled but is editable' do
      component.stub(:annulled? => false, :editable? => true)

      expect(subject.not_allow_submit_message).to be_nil
    end
  end

  context '#not_annullable_message' do
    it 'when is annulled' do
      component.stub(:annulled? => true)

      expect(subject.not_annullable_message).to be_nil
    end

    it 'when is not annulled nor editable' do
      I18n.backend.store_translations 'pt-BR', :purchase_solicitation_item_group => {
          :messages => {
            :not_annullable => 'não pode'
        }
      }

      component.stub(:annulled? => false, :editable? => false)

      expect(subject.not_annullable_message).to eq 'não pode'
    end

    it 'when is not annulled but is editable' do
      component.stub(:annulled? => false, :editable? => true)

      expect(subject.not_annullable_message).to be_nil
    end
  end
end
