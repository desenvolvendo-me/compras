# encoding: utf-8
require 'model_helper'
require 'app/models/expense_nature'
require 'app/models/purchase_solicitation'
require 'app/models/purchase_solicitation_budget_allocation'
require 'app/models/material'
require 'app/models/budget_allocation'
require 'app/models/pledge'

describe ExpenseNature do
  it 'should return expense nature and description as to_s method' do
    subject.expense_nature = '4.4.20.03.11111111'
    subject.description = "Descrição"
    expect(subject.to_s).to eq '4.4.20.03.11111111 - Descrição'
  end

  it { should belong_to :descriptor }
  it { should belong_to :regulatory_act }
  it { should belong_to :expense_group }
  it { should belong_to :expense_modality }
  it { should belong_to :expense_element }
end
