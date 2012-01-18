require 'model_helper'
require 'app/models/profile'
require 'app/models/role'
require 'app/models/user'

describe Profile do
  it 'return name on to_s' do
    subject.name = 'Admin'
    subject.name.should eq subject.to_s
  end

  it 'build roles' do
    subject.roles.should be_empty

    subject.build_role :controller => 'customers'
    subject.roles.should_not be_empty
  end

  it { should have_many :roles }
  it { should have_many :users }

  it { should validate_presence_of :name }

end
