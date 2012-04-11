# encoding: utf-8
require 'model_helper'
require 'app/models/regulatory_act'
require 'app/models/expense_nature'
require 'app/models/budget_unit_configuration'
require 'app/models/organogram_responsible'
require 'app/models/extra_credit'
require 'app/models/revenue_nature'
require 'app/models/licitation_modality'

describe RegulatoryAct do
  it 'should return act_number as to_s method' do
    subject.act_number = '01'
    subject.to_s.should eq '01'
  end

  it { should belong_to :regulatory_act_type }
  it { should belong_to :legal_text_nature }

  it { should have_one(:extra_credit) }
  it { should have_many(:expense_natures).dependent(:restrict) }
  it { should have_many(:budget_unit_configurations).dependent(:restrict) }
  it { should have_many(:organogram_responsibles).dependent(:restrict) }
  it { should have_many(:licitation_modalities).dependent(:restrict) }
  it { should have_many(:revenue_natures).dependent(:restrict) }

  it { should have_and_belong_to_many :dissemination_sources}
  it { should validate_presence_of :act_number }
  it { should validate_presence_of :regulatory_act_type }
  it { should validate_presence_of :creation_date }
  it { should validate_presence_of :publication_date }
  it { should validate_presence_of :vigor_date }
  it { should validate_presence_of :end_date }
  it { should validate_presence_of :content }
  it { should validate_presence_of :budget_law_percent }
  it { should validate_presence_of :revenue_antecipation_percent }
  it { should validate_presence_of :authorized_debt_value }
  it { should validate_presence_of :legal_text_nature }
  it { should validate_numericality_of :budget_law_percent }
  it { should validate_numericality_of :revenue_antecipation_percent }
  it { should validate_numericality_of :act_number }

  it "should not have vigor_date less than creation_date" do
    subject.creation_date = Date.current
    subject.vigor_date = subject.creation_date - 1.day

    subject.should_not be_valid

    subject.errors[:vigor_date].should include("deve ser em ou depois de #{I18n.l subject.creation_date}")
  end

  it "should not have publication_date less than creation_date" do
    subject.creation_date = Date.current
    subject.publication_date = subject.creation_date - 1.day

    subject.should_not be_valid

    subject.errors[:publication_date].should include("deve ser em ou depois de #{I18n.l subject.creation_date}")
  end

  it "should not have publication_date greater than vigor_date" do
    subject.vigor_date = Date.current
    subject.publication_date = subject.vigor_date + 1.day

    subject.should_not be_valid

    subject.errors[:publication_date].should include("deve ser em ou antes de #{I18n.l subject.vigor_date}")
  end

  it "should not have budget_law_percent greater than 100" do
    subject.budget_law_percent = 100.01

    subject.should_not be_valid

    subject.errors[:budget_law_percent].should include("deve ser menor ou igual a 100")
  end

  it "should not have revenue_antecipation_percent greater than 100" do
    subject.revenue_antecipation_percent = 100.01

    subject.should_not be_valid

    subject.errors[:revenue_antecipation_percent].should include("deve ser menor ou igual a 100")
  end
end
