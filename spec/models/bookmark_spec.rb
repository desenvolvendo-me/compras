require 'model_helper'
require 'app/models/bookmark'

describe Bookmark do
  it { should belong_to :user }
  it { should have_and_belong_to_many :links }

  it { should validate_presence_of :user }

  it 'convert to string using human model name' do
    expect(subject.to_s).to eq 'Favoritos'
  end
end
