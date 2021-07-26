require 'spec_helper'

class HeaderDecorator
  include Decore
  include Proxy
  include Header
end

class HeaderWithoutOptionsDecorator
  include Decore
  include Proxy
  include Header

  attr_header :name, :year, :height
end

class HeaderWithLinkDecorator
  include Decore
  include Proxy
  include Header

  attr_header :name, :year, :height, :link => :name
end

class HeaderWithoutToSDecorator
  include Decore
  include Proxy
  include Header

  attr_header :name, :year, :height, :link => :name, :to_s => false
end

describe Decore::Header do
  context 'when include Header' do
    it 'should respond_to headers?' do
      expect(HeaderDecorator.respond_to?(:headers?)).to be_true
    end

    it 'should respond_to link?' do
      expect(HeaderDecorator.respond_to?(:link?)).to be_true
    end

    it 'should respond_to header_attributes?' do
      expect(HeaderDecorator.respond_to?(:header_attributes)).to be_true
    end

    it 'should respond_to header_link_attributes?' do
      expect(HeaderDecorator.respond_to?(:header_link_attributes)).to be_true
    end
  end

  context 'without options' do
    describe '.header_attributes' do
      it 'should have name, year and height into header_attributes' do
        expect(HeaderWithoutOptionsDecorator.header_attributes).to include :name, :year, :height
      end
    end

    describe '.to_s' do
      it 'should have true as default' do
        expect(HeaderWithoutOptionsDecorator.to_s).to be_true
      end
    end

    describe '.header_link_attributes' do
      it 'should return the first attribute' do
        expect(HeaderWithoutOptionsDecorator.header_link_attributes).to eq Set[:name]
      end
    end

    describe '.link?' do
      it 'be true when the field is not a link and dont have to_s' do
        expect(HeaderWithoutOptionsDecorator.link?(:name)).to be_true
      end
    end
  end

  context 'with link' do
    describe '.header_link_attributes' do
      it 'should have name into header_link_attributes' do
        expect(HeaderWithLinkDecorator.header_link_attributes).to include :name
      end
    end

    describe '.link?' do
      it 'be false when the field is not a link' do
        expect(HeaderWithLinkDecorator.link?(:name)).to be_true
      end
    end
  end
end
