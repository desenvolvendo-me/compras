# encoding: utf-8
require 'model_helper'
require 'app/models/unico/company'
require 'app/models/unico/partner'
require 'app/models/partner'
require 'app/models/company'

describe Company do
  it 'must have at least one' do
    subject.valid?

    expect(subject.errors[:partners]).to include 'deve haver ao menos um sócio'
  end
end
