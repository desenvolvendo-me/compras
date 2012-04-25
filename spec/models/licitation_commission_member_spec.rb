# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_commission_member'

describe LicitationCommissionMember do
  it { should belong_to :licitation_commission }
  it { should belong_to :individual }

  it { should validate_presence_of :individual }
  it { should validate_presence_of :role }
  it { should validate_presence_of :role_nature }
  it { should validate_presence_of :registration }

  it 'should get the correct attributes for data' do
    individual = double(:cpf => 'cpf 1', :to_s => 'name 1')

    subject.stub(:individual_id).and_return(5)
    subject.stub(:role).and_return('role 1')
    subject.stub(:role_nature).and_return('role nature 1')
    subject.stub(:registration).and_return('registration 1')
    subject.stub(:role_humanize).and_return('role humanize 1')
    subject.stub(:role_nature_humanize).and_return('role nature humanize 1')
    subject.stub(:individual).and_return(individual)

    subject.attributes_for_data.should eq({ 'individual_id' => 5,
                                            'role' => 'role 1',
                                            'role_nature' => 'role nature 1',
                                            'registration' => 'registration 1',
                                            'role_humanize' => 'role humanize 1',
                                            'role_nature_humanize' => 'role nature humanize 1',
                                            'individual_name' => 'name 1',
                                            'cpf' => 'cpf 1' })
  end

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
