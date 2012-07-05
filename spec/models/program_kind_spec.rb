# encoding: utf-8
require 'model_helper'
require 'app/models/program_kind'

describe ProgramKind do
  it { should validate_presence_of :specification }

  it 'should return specification as to_s' do
    subject.specification = 'Apoio Administrativo'

    subject.to_s.should eq 'Apoio Administrativo'
  end
end
