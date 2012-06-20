require 'unit_helper'
require 'active_support/core_ext/module/delegation'
require 'app/business/expense_nature_code_generator'

describe ExpenseNatureCodeGenerator do
  subject do
    described_class.new(expense_nature_object)
  end

  context 'when have all codes' do
    let :expense_nature_object do
      double(
        :expense_category_code => '1',
        :expense_group_code => '2',
        :expense_modality_code => '33',
        :expense_element_code => '44',
        :expense_split => '55',
      )
    end

    it 'should generate full_code' do
      expense_nature_object.should_receive(:expense_nature=).with('1.2.33.44.55')
      subject.generate!
    end
  end

  context 'when have code missing' do
    let :expense_nature_object do
      double(
        :expense_category_code => '1',
        :expense_group_code => nil,
        :expense_modality_code => '33',
        :expense_element_code => nil,
        :expense_split => nil,
      )
    end

    it 'should use 0' do
      expense_nature_object.should_receive(:expense_nature=).with('1.0.33.00.00')
      subject.generate!
    end
  end

  context 'when have modality_code only with 1 of length' do
    let :expense_nature_object do
      double(
        :expense_category_code => nil,
        :expense_group_code => nil,
        :expense_modality_code => nil,
        :expense_element_code => '1',
        :expense_split => nil,
      )
    end

    it 'should generate full_code with 0 on left' do
      expense_nature_object.should_receive(:expense_nature=).with('0.0.00.01.00')
      subject.generate!
    end
  end
end
