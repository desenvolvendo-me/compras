# encoding: utf-8
require 'spec_helper'

describe User do
  it 'validate uniqueness of authenticable_id scoped to authenticable_type' do
    user = User.make!(:wenderson)

    subject.authenticable_type = user.authenticable_type
    subject.authenticable_id = user.authenticable_id

    subject.valid?

    expect(subject.errors[:authenticable_id]).to include 'já está em uso'
  end
end