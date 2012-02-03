# encoding: utf-8
require 'model_helper'
require 'app/models/administractive_act'

describe AdministractiveAct do
  it 'should return act_number as to_s method' do
    subject.act_number = '01'
    subject.to_s.should eq '01'
  end

  it { should belong_to :type_of_administractive_act }
  it { should belong_to :legal_texts_nature }
  it { should have_and_belong_to_many :dissemination_sources}
  it { should validate_presence_of :act_number }
  it { should validate_presence_of :type_of_administractive_act_id }
  it { should validate_presence_of :creation_date }
  it { should validate_presence_of :publication_date }
  it { should validate_presence_of :vigor_date }
  it { should validate_presence_of :end_date }
  it { should validate_presence_of :content }
  it { should validate_presence_of :budget_law_percent }
  it { should validate_presence_of :revenue_antecipation_percent }
  it { should validate_presence_of :authorized_debt_value }
  it { should validate_presence_of :legal_texts_nature_id }
  it { should validate_numericality_of :budget_law_percent }
  it { should validate_numericality_of :revenue_antecipation_percent }
  it { should validate_numericality_of :act_number }

  it "should not have vigor_date less than creation_date" do
    subject.creation_date = Date.current
    subject.vigor_date = subject.creation_date - 1.day

    subject.should_not be_valid

    subject.errors[:vigor_date].should include("não pode ser menor que a data de criação")
  end

  it "should not have publication_date less than creation_date" do
    subject.creation_date = Date.current
    subject.publication_date = subject.creation_date - 1.day

    subject.should_not be_valid

    subject.errors[:publication_date].should include("não pode ser menor que a data de criação")
  end

  it "should not have publication_date greater than vigor_date" do
    subject.vigor_date = Date.current
    subject.publication_date = subject.vigor_date + 1.day

    subject.should_not be_valid

    subject.errors[:publication_date].should include("não pode ser maior que a data a vigorar")
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
