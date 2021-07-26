require 'model_helper'
require 'app/models/persona/company'
require 'app/models/persona/partner'
require 'app/models/partner'
require 'app/models/company'

describe Company do
  it 'must have at least one' do
    subject.valid?

    expect(subject.errors[:partners]).to include 'deve haver ao menos um sócio'
  end
end
