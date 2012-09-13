# encoding: utf-8
require 'model_helper'
require 'app/models/account_plan_level'
require 'app/models/account_plan_configuration'
require 'app/enumerations/account_plan_separator'

describe AccountPlanConfiguration do
  it { should belong_to :state }

  it { should have_many(:account_plan_levels).dependent(:destroy) }

  it { should validate_presence_of :description }
  it { should validate_presence_of :state }
  it { should validate_presence_of :year }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('212').for(:year) }
  it { should_not allow_value('2a12').for(:year) }

  context '#to_s' do
    it 'should return description at to_s call' do
      subject.description = 'Plano1'

      expect(subject.to_s).to eq 'Plano1'
    end
  end

  context 'mask' do
    let :level_1 do
      AccountPlanLevel.new(:level => 1, :digits => 1, :separator => AccountPlanSeparator::SLASH)
    end

    let :level_2 do
      AccountPlanLevel.new(:level => 2, :digits => 2)
    end

    subject do
      described_class.new :account_plan_levels => [level_2, level_1]
    end

    context 'generate' do
      it 'should return correct mask' do
        expect(subject.mask).to eq '9/99'
      end
    end

    context 'validate level' do
      it 'should validate presence of level only on last mask' do
        level_1.separator = nil
        expect(subject).not_to be_valid
        expect(subject.ordered_account_plan_levels.first.errors[:separator]).to include 'não pode ficar em branco'
        expect(subject.ordered_account_plan_levels.last.errors[:separator]).to_not include 'não pode ficar em branco'
      end

      it 'should return incorrect mask when digits is missing' do
        level_1.digits = nil
        expect(subject.mask).to eq '99'
      end
    end
  end
end
