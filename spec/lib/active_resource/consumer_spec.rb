require 'spec_helper'

class Dummy < UnicoAPI::Consumer
  include I18n::Alchemy

  schema do
    date :date_field
    decimal :decimal_field
  end
end

describe UnicoAPI::Consumer do
  subject { Dummy.new }

  describe "attribute localization" do
    it 'localizes the passed attributes' do
      subject.localized.attributes = { date_field: '08/05/2013', decimal_field: '12,34' }

      expect(subject.attributes["date_field"]).to eql "2013-05-08"
      expect(subject.attributes["decimal_field"]).to eql "12.34"
    end

    it 'parses the localized the attributes' do
      subject.localized({ date_field: '08/05/2013', decimal_field: '12,34' }).parse_attributes!

      expect(subject.attributes["date_field"]).to eql Date.new(2013, 5, 8)
      expect(subject.attributes["decimal_field"]).to eql 12.34
    end

    it "doesn't localize attributes that aren't in the schema" do
      subject.localized.attributes = { foo_field: '10/08/2013', bar_field: '56,78' }

      expect(subject.attributes["foo_field"]).to eql "10/08/2013"
      expect(subject.attributes["bar_field"]).to eql "56,78"
    end

    it "doesn't localize attributes when not using the localized method" do
      subject.attributes = { date_field: '08/05/2013', decimal_field: '12,34' }

      expect(subject.attributes[:date_field]).to eql "08/05/2013"
      expect(subject.attributes[:decimal_field]).to eql "12,34"
    end
  end
end
