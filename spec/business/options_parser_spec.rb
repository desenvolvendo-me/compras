require 'unit_helper'
require 'app/business/options_parser'

describe OptionsParser do
  describe "#parse" do
    it 'receives a string and splits it into an array' do
      subject = OptionsParser.new("foo, bar,baz ")

      expect(subject.parse).to eq %w(foo bar baz)
    end

    it 'also accepts a hash' do
      subject = OptionsParser.new("01 - foo, 02-bar, 03- baz, 04 -qux")

      expect(subject.parse).to eq([
        ["01 - foo", "01"],
        ["02-bar", "02"],
        ["03- baz", "03"],
        ["04 -qux", "04"],
      ])
    end
  end
end
