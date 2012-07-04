require 'model_helper'
require 'app/models/user'
require 'app/models/bookmark'

describe User do
  describe 'default values' do
    it 'uses false as default for administrator' do
      subject.administrator.should be false
    end
  end

  it "return login on to_s" do
    subject.stub(:login).and_return('gabriel.sobrinho')
    subject.to_s.should eq 'gabriel.sobrinho'
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

  it 'requires login if the user is not an creditor' do
    subject.stub(:creditor?).and_return false

    subject.should validate_presence_of :login
  end

  it 'do not require login if the use is a creditor' do
    subject.stub(:creditor?).and_return true

    subject.should_not validate_presence_of :login
  end

  it 'require the login for persisted users' do
    subject.stub(:persisted?).and_return true

    subject.should validate_presence_of :login
  end

  describe 'password required for creditor' do
    it 'should not require the password if the user is a creditor and no persisted' do
      subject.should_receive(:creditor?).and_return true
      subject.should_receive(:persisted?).and_return false

      subject.should_not be_password_required
    end

    it 'should require the password if the user is a creditor and is persisted but not confimed' do
      subject.should_receive(:creditor?).and_return true
      subject.should_receive(:persisted?).and_return true
      subject.should_receive(:confirmed?).and_return false

      subject.should be_password_required
    end

    it 'should not require the password if the user is a creditor, is persisted and confirmed' do
      subject.should_receive(:creditor?).and_return true
      subject.should_receive(:persisted?).and_return true
      subject.should_receive(:confirmed?).and_return true

      subject.should_not be_password_required
    end
  end

  it { should have_one :bookmark }
  it { should belong_to :profile }

  it { should validate_presence_of :login }

  it "shoud not validate presence of profile when user is an admin" do
    subject.stub(:administrator?).and_return(true)
    subject.should_not validate_presence_of :profile
  end

  it "shoud validate presence of profile when user is not an admin" do
    subject.stub(:administrator?).and_return(false)
    subject.should validate_presence_of :profile
  end

  it "shoud validate presence of employee when user is not an admin" do
    subject.stub(:administrator?).and_return(false)
    subject.should validate_presence_of :authenticable
  end

  it 'should not validate presence of profile when user is a creditor' do
    subject.stub(:creditor?).and_return true
    subject.should_not validate_presence_of :profile
  end

  describe '#administrator_or_creditor?' do
    it 'should be true when is a administrator?' do
      subject.stub(:administrator?).and_return true

      subject.should be_administrator_or_creditor
    end

    it 'should be true when is a creditor?' do
      subject.stub(:creditor?).and_return true

      subject.should be_administrator_or_creditor
    end

    it 'should be false when is not an administrator neither a creditor' do
      subject.should_not be_administrator_or_creditor
    end
  end
end
