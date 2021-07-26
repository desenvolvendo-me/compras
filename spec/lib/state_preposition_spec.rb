require 'unit_helper'
require 'active_support/core_ext'
require 'lib/state_preposition'

describe StatePreposition do
  subject do
    StatePreposition.new('paraná')
  end

  it "should return formated state name with right preposition" do
    expect(subject.format).to eq 'ESTADO DO PARANÁ'
  end

  describe 'With valid state name for preposition DA' do
    it "should return the preposition DA" do
      expect(StatePreposition.new('BAHIA').preposition).to eq 'DA'
    end
  end

  describe 'With valid state name for preposition DE' do
    it "should return the preposition DE" do
      expect(StatePreposition.new('ALAGOAS').preposition).to eq 'DE'
    end
  end

  describe 'With valid state name for preposition DO' do
    it "should return the preposition DO" do
      expect(StatePreposition.new('AMAZONAS').preposition).to eq 'DO'
    end
  end

  describe 'With invalid state name' do
    it "should return the preposition DO" do
      expect(StatePreposition.new('foo').preposition).to eq 'DO'
    end
  end
end
