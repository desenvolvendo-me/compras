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
      expect(subject.roles).to have(:no).records

      subject.build_role(:controller => 'customers')
      expect(subject.roles).to have(1).record
    end
  end

  it 'return name on to_s' do
    subject.name = 'management'
    expect(subject.to_s).to eq 'management'
  end

  context '#delete_role' do
    before do
      subject.stub(:roles).and_return(roles)
    end

    let :roles do
      [role]
    end

    let :role do
      double(:role)
    end

    it 'deletes role' do
      expect(subject.roles).to have(1).record

      subject.delete_role(role)
      expect(subject.roles).to have(:no).records
    end
  end
end
