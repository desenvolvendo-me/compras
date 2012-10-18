# encoding: utf-8
require 'spec_helper'

describe Creditor do
  it 'validate uniqueness of creditable_id scoped to creditable_type' do
    creditor = Creditor.make!(:special)

    subject.creditable_type = creditor.creditable_type
    subject.creditable_id = creditor.creditable_id

    subject.valid?

    expect(subject.errors[:creditable_id]).to include 'já está em uso'
  end
end