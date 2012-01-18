# encoding: utf-8
require 'model_helper'
require 'app/models/setting'

describe Setting do
  it { should validate_presence_of :key }

  it 'fetch setting value' do
    Setting.should_receive(:find_by_key).with('default_city').and_return(double(:value => '1'))

    Setting.fetch('default_city').should eq '1'
  end

  it 'do not fetch value for inexistent setting' do
    Setting.should_receive(:find_by_key).with('default_country').and_return(nil)

    Setting.fetch('default_country').should be_nil
  end

  it 'to_s return key attribute' do
    I18n.should_receive(:translate).with('default_city', :scope => :settings).and_return('Cidade')

    subject.key = 'default_city'
    subject.to_s.should eq 'Cidade'
  end
end
