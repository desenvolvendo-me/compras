# encoding: utf-8
require 'model_helper'
require 'app/models/link'

describe Link do
  it { should have_and_belong_to_many :bookmarks }
  it { should validate_presence_of :controller_name }

  it 'sorts using controller name' do
    users = mock('link', :to_s => 'Usuários')
    people = mock('link', :to_s => 'Pessoas')

    described_class.should_receive(:all).and_return([users, people])
    described_class.ordered.should eq [people, users]
  end

  it 'convert to string using controller name' do
    subject.controller_name = 'users'
    subject.to_s.should eq 'Usuários'
  end
end
