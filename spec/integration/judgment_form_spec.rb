# encoding: UTF-8
require 'spec_helper'

describe JudgmentForm do
  context 'uniqueness validations' do
    before { JudgmentForm.make!(:global_com_menor_preco) }

    it { should validate_uniqueness_of(:description) }
    it { should validate_uniqueness_of(:kind).scoped_to(:licitation_kind).with_message(:already_in_use_for_this_licitation_kind) }
  end

  describe '.enabled' do
    let(:judment_form_enabled) { JudgmentForm.make!(:global_com_menor_preco) }
    let(:judment_form_disabled) { JudgmentForm.make!(:global, :enabled => false) }

    it 'should returns only judgment forms enabled' do
      expect(described_class.enabled).to eq [judment_form_enabled]
    end
  end
end
