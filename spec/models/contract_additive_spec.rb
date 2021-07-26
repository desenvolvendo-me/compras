require 'model_helper'
require 'app/models/contract_additive'

describe ContractAdditive do
  it { should belong_to :contract }

  it { should validate_presence_of(:number) }
  it { should validate_presence_of(:additive_type) }
  it { should validate_presence_of(:signature_date) }
  it { should validate_presence_of(:publication_date) }
  it { should validate_presence_of(:dissemination_source) }

  it "requires end_date only if type is extension_term" do
    subject.additive_type = ContractAdditiveType::EXTENSION_TERM
    subject.end_date = nil

    subject.valid?

    expect(subject.errors[:end_date]).to include "não pode ficar em branco"
  end

  it "doesnt require end_date if type is not extension_term" do
    subject.additive_type = ContractAdditiveType::OTHERS
    subject.end_date = nil

    subject.valid?

    expect(subject.errors[:end_date]).not_to include "não pode ficar em branco"
  end

  context "value is mandatory only if type is one of these: value_additions, value_decrease, readjustment, recomposition" do
    before do
      subject.value = nil
    end

    it "requires value if type is value_additions" do
      subject.additive_type = ContractAdditiveType::VALUE_ADDITIONS

      subject.valid?

      expect(subject.errors[:value]).to include "não pode ficar em branco"
    end

    it "requires value if type is value_decrease" do
      subject.additive_type = ContractAdditiveType::VALUE_DECREASE

      subject.valid?

      expect(subject.errors[:value]).to include "não pode ficar em branco"
    end

    it "requires value if type is readjustment" do
      subject.additive_type = ContractAdditiveType::READJUSTMENT

      subject.valid?

      expect(subject.errors[:value]).to include "não pode ficar em branco"
    end

    it "requires value if type is recomposition" do
      subject.additive_type = ContractAdditiveType::READJUSTMENT

      subject.valid?

      expect(subject.errors[:value]).to include "não pode ficar em branco"
    end
  end

  context "value is not mandatory if type is diferent form these: value_additions, value_decrease, readjustment, recomposition" do
    it "doesnt requires value" do
      subject.additive_type = ContractAdditiveType::OTHERS

      subject.valid?

      expect(subject.errors[:value]).not_to include "não pode ficar em branco"
    end
  end
end
