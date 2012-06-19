require 'unit_helper'
require 'cancan/ability'
require 'cancan/rule'
require 'cancan/matchers'
require 'lib/ability'

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

    ability.should be_able_to :read, :something
    ability.should be_able_to :create, :something
    ability.should be_able_to :update, :something
  end

  it 'alias filter and modal to read' do
    ability = Ability.new
    ability.can(:read, :something)

    ability.should be_able_to :filter, :something
    ability.should be_able_to :modal, :something
  end

  it 'should be able to access accounts and bookmarks' do
    ability = Ability.new(user)

    ability.should be_able_to :access, :accounts
    ability.should be_able_to :access, :bookmarks
  end

  it 'should be able to access all if user is administrator' do
    ability = Ability.new(admin)

    ability.should be_able_to :access, :all
  end

  it 'should not be able to access all if user is administrator' do
    ability = Ability.new(user)

    ability.should_not be_able_to :access, :all
  end

  it 'should be able to access which roles permits' do
    ability = Ability.new(user)

    ability.should be_able_to :read, :something
    ability.should be_able_to :create, :something
    ability.should be_able_to :update, :something
    ability.should be_able_to :destroy, :something
  end

  context 'ability for creditor user' do
    let :creditor do
      double('user', :administrator? => false, :creditor? => true, :authenticable_id => 1)
    end

    subject { Ability.new(creditor) } 

    it 'should be able to access accounts and bookmarks' do
      subject.should be_able_to :access, :bookmarks
      subject.should be_able_to :access, :accounts
    end

    it 'should be able to read and update his owm proposals' do
      subject.should be_able_to :read, :price_collection_proposals
      subject.should be_able_to :update, :price_collection_proposals
    end
  end
end
