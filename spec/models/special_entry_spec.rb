require 'model_helper'
require 'app/models/special_entry'

describe SpecialEntry do
  it { should validate_presence_of :name }

  context '#to_s' do
    it 'should return name at to_s calls' do
      subject.name = 'Tal'

      expect(subject.to_s).to eq 'Tal'
    end
  end
end
