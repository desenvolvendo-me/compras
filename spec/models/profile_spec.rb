require 'model_helper'
require 'app/models/profile'
require 'app/models/role'
require 'app/models/user'

describe Profile do
  it { should have_many :roles }
  it { should have_many :users }

  it { should validate_presence_of :name }

  context '#build_role' do
    it 'builds role' do
      subject.roles.should have(:no).records

      subject.build_role(:controller => 'customers')
      subject.roles.should have(1).record
    end
  end

  it 'return name on to_s' do
    subject.name = 'management'
    subject.to_s.should eq 'management'
  end
end
