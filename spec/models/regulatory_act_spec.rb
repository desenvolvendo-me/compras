# encoding: utf-8
require 'model_helper'
require 'app/models/regulatory_act'
require 'app/models/expense_nature'
require 'app/models/budget_structure_configuration'
require 'app/models/budget_structure_responsible'

describe RegulatoryAct do
  it 'should return act_number as to_s method' do
    subject.stub(:regulatory_act_type).and_return('Lei')
    subject.act_number = '01'
    expect(subject.to_s).to eq 'Lei 01'
  end

  it { should belong_to :regulatory_act_type }
  it { should belong_to :legal_text_nature }

  it { should have_many(:expense_natures).dependent(:restrict) }
  it { should have_many(:budget_structure_configurations).dependent(:restrict) }
  it { should have_many(:budget_structure_responsibles).dependent(:restrict) }

  it { should have_and_belong_to_many :dissemination_sources}
  it { should validate_presence_of :act_number }
  it { should validate_presence_of :regulatory_act_type }
  it { should validate_presence_of :creation_date }
  it { should validate_presence_of :signature_date }
  it { should validate_presence_of :publication_date }
  it { should validate_presence_of :vigor_date }
  it { should validate_presence_of :content }
  it { should validate_presence_of :legal_text_nature }
  it { should validate_numericality_of :budget_law_percent }
  it { should validate_numericality_of :revenue_antecipation_percent }
  it { should validate_numericality_of :act_number }

  it 'should have zero as default value to budget_law_percent' do
    expect(subject.budget_law_percent).to eq 0.0
  end

  it 'should have zero as default value to revenue_antecipation_percent' do
    expect(subject.revenue_antecipation_percent).to eq 0.0
  end

  it 'should have zero as default value to authorized_debt_value' do
    expect(subject.authorized_debt_value).to eq 0.0
  end

  context 'validate vigor_date related with creation_date' do
    let :creation_date do
      Date.current + 10.days
    end

    before do
      subject.stub(:creation_date).and_return(creation_date)
    end

    it 'should allow vigor_date date after creation_date' do
      expect(subject).to allow_value(Date.current + 15.days).for(:vigor_date)
    end

    it 'should allow vigor_date date equals to creation_date' do
      expect(subject).to allow_value(creation_date).for(:vigor_date)
    end

    it 'should not allow vigor_date date before creation_date' do
      expect(subject).not_to allow_value(Date.current).for(:vigor_date).
                                                   with_message("deve ser igual ou posterior a data de criação (#{I18n.l creation_date})")
    end
  end

  context 'validate publication_date related with creation_date' do
    let :creation_date do
      Date.current + 10.days
    end

    before do
      subject.stub(:vigor_date).and_return(creation_date + 20.days)
      subject.stub(:creation_date).and_return(creation_date)
    end

    it 'should allow publication_date date after creation_date' do
      expect(subject).to allow_value(Date.current + 15.days).for(:publication_date)
    end

    it 'should allow publication_date date equals to creation_date' do
      expect(subject).to allow_value(creation_date).for(:publication_date)
    end

    it 'should not allow publication_date date before creation_date' do
      expect(subject).not_to allow_value(Date.current).for(:publication_date).
                                                   with_message("deve ser igual ou posterior a data de criação (#{I18n.l creation_date})")
    end
  end

  context 'validate publication_date related with vigor_date' do
    let :vigor_date do
      Date.current + 10.days
    end

    before do
      subject.stub(:creation_date).and_return(Date.current)
      subject.stub(:vigor_date).and_return(vigor_date)
    end

    it 'should allow publication_date before vigor_date' do
      expect(subject).to allow_value(vigor_date - 5.days).for(:publication_date)
    end

    it 'should allow publication_date equals to vigor_date' do
      expect(subject).to allow_value(vigor_date).for(:publication_date)
    end

    it 'should not allow publication_date after vigor_date' do
      expect(subject).not_to allow_value(vigor_date + 5.days).for(:publication_date).
                                                          with_message("deve ser em ou antes da data a vigorar (#{I18n.l vigor_date})")
    end
  end

  it 'should not allow budget_law_percent greater than 100' do
    expect(subject).not_to allow_value(101).for(:budget_law_percent).
                                           with_message('deve ser menor ou igual a 100')
  end

  it 'should not allow revenue_antecipation_percent greater than 100' do
    expect(subject).not_to allow_value(101).for(:revenue_antecipation_percent).
                                           with_message('deve ser menor ou igual a 100')
  end
end
