require 'model_helper'
require 'app/models/user'
require 'app/models/bookmark'

describe User do
  describe 'default values' do
    it 'uses false as default for administrator' do
      expect(subject.administrator).to be false
    end
  end

  xit "return login on to_s" do
    subject.stub(:login).and_return('gabriel.sobrinho')
    expect(subject.to_s).to eq 'gabriel.sobrinho'
  end

  it "require password" do
    expect(subject).to be_password_required
  end

  it "require password unless persisted" do
    subject.should_receive(:persisted?).and_return(true)
    expect(subject).not_to be_password_required
  end

  it "require password if password is present" do
    subject.should_receive(:persisted?).and_return(true)
    subject.password = '123456'

    expect(subject).to be_password_required
  end

  it "required password if password confirmation is present" do
    subject.should_receive(:persisted?).and_return(true)
    subject.password_confirmation = '123456'

    expect(subject).to be_password_required
  end

  xit 'requires login if the user is not an creditor' do
    subject.stub(:creditor?).and_return false

    subject.should validate_presence_of :login
  end

  xit 'do not require login if the use is a creditor' do
    subject.stub(:creditor?).and_return true

    expect(subject).not_to validate_presence_of :login
  end

  xit 'require the login for persisted users' do
    subject.stub(:persisted?).and_return true

    subject.should validate_presence_of :login
  end

  describe 'password required for creditor' do
    it 'should not require the password if the user is a creditor and no persisted' do
      subject.should_receive(:creditor?).and_return true
      subject.should_receive(:persisted?).and_return false

      expect(subject).not_to be_password_required
    end

    it 'should require the password if the user is a creditor and is persisted but not confimed' do
      subject.should_receive(:creditor?).and_return true
      subject.should_receive(:persisted?).and_return true
      subject.should_receive(:confirmed?).and_return false

      expect(subject).to be_password_required
    end

    it 'should not require the password if the user is a creditor, is persisted and confirmed' do
      subject.should_receive(:creditor?).and_return true
      subject.should_receive(:persisted?).and_return true
      subject.should_receive(:confirmed?).and_return true

      expect(subject).not_to be_password_required
    end
  end

  it { should have_one :bookmark }
  it { should belong_to :profile }

  it { should validate_presence_of :login }

  xit "shoud not validate presence of profile when user is an admin" do
    subject.stub(:administrator?).and_return(true)
    expect(subject).not_to validate_presence_of :profile
  end

  xit "shoud validate presence of profile when user is not an admin" do
    subject.stub(:administrator?).and_return(false)
    subject.should validate_presence_of :profile
  end

  xit "shoud validate presence of employee when user is not an admin" do
    subject.stub(:administrator?).and_return(false)
    subject.should validate_presence_of :authenticable
  end

  xit 'should not validate presence of profile when user is a creditor' do
    subject.stub(:creditor?).and_return true
    expect(subject).not_to validate_presence_of :profile
  end

  describe '#administrator_or_creditor?' do
    xit 'should be true when is a administrator?' do
      subject.stub(:administrator?).and_return true

      expect(subject).to be_administrator_or_creditor
    end

    xit 'should be true when is a creditor?' do
      subject.stub(:creditor?).and_return true

      expect(subject).to be_administrator_or_creditor
    end

    it 'should be false when is not an administrator neither a creditor' do
      expect(subject).not_to be_administrator_or_creditor
    end
  end

  describe '#skip_confirmation' do
    before { subject.stub(:send_on_create_confirmation_instructions).and_return(nil) }

    let(:now) { double(:now, :utc => 'utc') }

    context 'when is an administrator' do
      before do
        Time.stub(:now).and_return(now)

        subject.stub(:administrator?).and_return(true)
      end

      xit 'should be confirmed' do
        subject.should_receive(:confirmed_at=).with(now.utc)

        subject.run_callbacks(:create)
      end
    end

    context 'when is not an administrator' do
      before { subject.stub(:administrator?).and_return(false) }

      xit 'should be not confirmed' do
        subject.should_not_receive(:confirmed_at=)

        subject.run_callbacks(:create)
      end
    end
  end
end
