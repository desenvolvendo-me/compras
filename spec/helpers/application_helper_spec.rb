require 'spec_helper'

describe ApplicationHelper do
  context '#message_about_environment?' do
    it 'should be false on production' do
      Rails.stub(:env).and_return(ActiveSupport::StringInquirer.new('production'))

      helper.message_about_environment?.should be_false
    end

    it 'should be true on staging' do
      Rails.stub(:env).and_return(ActiveSupport::StringInquirer.new('staging'))

      helper.message_about_environment?.should be_true
    end

    it 'should be true on development' do
      Rails.stub(:env).and_return(ActiveSupport::StringInquirer.new('development'))

      helper.message_about_environment?.should be_true
    end

    it 'should be true on test' do
      Rails.stub(:env).and_return(ActiveSupport::StringInquirer.new('test'))

      helper.message_about_environment?.should be_true
    end
  end
end
