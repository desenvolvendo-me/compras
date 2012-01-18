require 'model_helper'
require 'app/models/user'
require 'app/models/bookmark'

describe User do
  it "return name on to_s" do
    subject.name = 'Gabriel Sobrinho'
    subject.name.should eq subject.to_s
  end

  it "require password" do
    subject.should be_password_required
  end

  it "require password unless persisted" do
    subject.should_receive(:persisted?).and_return(true)
    subject.should_not be_password_required
  end

  it "require password if password is present" do
    subject.should_receive(:persisted?).and_return(true)
    subject.password = '123456'

    subject.should be_password_required
  end

  it "required password if password confirmation is present" do
    subject.should_receive(:persisted?).and_return(true)
    subject.password_confirmation = '123456'

    subject.should be_password_required
  end

  it { should have_one :bookmark }
  it { should belong_to :profile }

  it { should validate_presence_of :name }
  it { should validate_presence_of :login }

  it "shoud not validate presence of profile when user is an admin" do
    subject.stub(:administrator?).and_return(true)
    subject.should_not validate_presence_of :profile
  end

  it "shoud validate presence of profile when user is not an admin" do
    subject.stub(:administrator?).and_return(false)
    subject.should validate_presence_of :profile
  end
end
