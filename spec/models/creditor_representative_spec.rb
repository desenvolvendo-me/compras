# encoding: utf-8
require 'model_helper'
require 'app/models/creditor_representative'
require 'app/models/persona/person'
require 'app/models/person'

describe CreditorRepresentative do
  it { should belong_to :creditor }
  it { should belong_to :representative_person }

  it { should delegate(:name).to(:representative_person).allowing_nil(true) }
  it { should delegate(:identity_document).to(:representative_person).allowing_nil(true) }

  it 'should to_s return representative_person' do
    representative_person = Person.new(:name => 'foo')

    subject.stub(:representative_person).and_return(representative_person)

    expect(subject.to_s).to eq 'foo'
  end
end
