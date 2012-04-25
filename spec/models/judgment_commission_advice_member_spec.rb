# encoding: utf-8
require 'model_helper'
require 'app/models/judgment_commission_advice_member'

describe JudgmentCommissionAdviceMember do
  it { should belong_to :judgment_commission_advice }
  it { should belong_to :individual }

  it { should validate_presence_of :individual }
  it { should validate_presence_of :role }
  it { should validate_presence_of :role_nature }
  it { should validate_presence_of :registration }

  it 'should return to hash correctly' do
    subject.individual_id = 3
    subject.registration = 'registration'
    subject.role = 'role'
    subject.role_nature = 'role nature'

    subject.to_hash.should eq({:individual_id => 3,
                               :registration => 'registration',
                               :role => 'role',
                               :role_nature => 'role nature' })
  end
end
