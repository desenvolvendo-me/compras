require 'spec_helper'
require 'cancan/ability'
require 'cancan/rule'
require 'cancan/matchers'

# cancan dependency
require 'active_support/core_ext/object/blank'

describe Ability do
  let :role do
    double('role', :permission => 'access', :controller => 'something')
  end

  let :user do
    double('user', :administrator? => false, :creditor? => false, :roles => [role])
  end

  let :admin do
    double('user', :administrator? => true)
  end

  it 'alias read, create and update to modify' do
    ability = Ability.new
    ability.can(:modify, :something)

    expect(ability).to be_able_to :read, :something
    expect(ability).to be_able_to :create, :something
    expect(ability).to be_able_to :update, :something
  end

  it 'alias filter and modal to read' do
    ability = Ability.new
    ability.can(:read, :something)

    expect(ability).to be_able_to :filter, :something
    expect(ability).to be_able_to :modal, :something
  end

  it 'alias modal and modal_info to search' do
    ability = Ability.new
    ability.can(:search, :something)

    expect(ability).to be_able_to :modal, :something
    expect(ability).to be_able_to :modal_info, :something
  end

  it 'should be able to access accounts and bookmarks' do
    ability = Ability.new(user)

    expect(ability).to be_able_to :access, :accounts
    expect(ability).to be_able_to :access, :bookmarks
  end

  it 'should be able to access all if user is administrator' do
    ability = Ability.new(admin)

    expect(ability).to be_able_to :access, :all
  end

  it 'should not be able to access all if user is administrator' do
    ability = Ability.new(user)

    expect(ability).not_to be_able_to :access, :all
  end

  it 'should be able to access which roles permits' do
    ability = Ability.new(user)

    expect(ability).to be_able_to :read, :something
    expect(ability).to be_able_to :create, :something
    expect(ability).to be_able_to :update, :something
    expect(ability).to be_able_to :destroy, :something
  end

  context 'ability for creditor user' do
    let :creditor do
      double('user', :administrator? => false, :creditor? => true, :authenticable_id => 1)
    end

    subject { Ability.new(creditor) } 

    it 'should be able to access accounts and bookmarks' do
      expect(subject).to be_able_to :access, :bookmarks
      expect(subject).to be_able_to :access, :accounts
    end

    it 'should be able to read and update his owm proposals' do
      expect(subject).to be_able_to :read, :price_collection_proposals
      expect(subject).to be_able_to :update, :price_collection_proposals
    end
  end

  it 'should be able to search through the role dependencies' do
    role.stub(:controller => 'creditors')
    ability = Ability.new(user)

    expect(ability).to be_able_to :search, 'materials'
  end
end
