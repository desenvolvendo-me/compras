require 'model_helper'
require 'app/models/property'
require 'app/models/owner'

describe Property do
  it 'should respond to_s as property_registration' do
    subject.property_registration = '001.999.190'
    subject.to_s.should eq '001.999.190'
  end

  it { should have_many(:owners).dependent(:restrict) }

  context 'should returm owner as first owner' do
    let :primary_owner do
      double.as_null_object
    end

    let :secundary_owner do
      double.as_null_object
    end

    it 'should return owner as first owner' do
      subject.stub(:owners).and_return([primary_owner, secundary_owner])
      subject.owner.should be primary_owner
    end
  end
end
