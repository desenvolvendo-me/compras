# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_commission_member'
require 'app/models/judgment_commission_advice_member'

describe LicitationCommissionMember do
  it { should belong_to :licitation_commission }
  it { should belong_to :individual }

  it { should have_many(:judgment_commission_advice_members).dependent(:restrict) }

  it { should validate_presence_of :individual }
  it { should validate_presence_of :role }
  it { should validate_presence_of :role_nature }
  it { should validate_presence_of :registration }

  it 'should return the individual_to_s as to_s method' do
    individual = double(:to_s => 'name 1')

    subject.stub(:individual).and_return(individual)

    subject.to_s.should eq 'name 1'
  end
end
