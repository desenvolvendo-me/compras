# encoding: utf-8
require 'model_helper'
require 'lib/annullable'
require 'app/models/resource_annul'

describe ResourceAnnul do
  it { should belong_to :annullable }
  it { should belong_to :employee }

  it { should validate_presence_of :date }
  it { should validate_presence_of :employee }
  it { should validate_presence_of :annullable }

  context '#annulled?' do
    let :annullable do
      double(:annullable, :annulled? => true)
    end

    it 'delegates to annullable' do
      subject.stub(:annullable => annullable)

      expect(subject).to be_annulled
    end
  end
end
