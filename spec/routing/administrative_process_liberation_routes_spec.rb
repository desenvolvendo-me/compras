require 'spec_helper'

describe "routing to administrative_process_liberation" do
  it 'should not expose index route' do
    { :get => '/administrative_process_liberations' }.should_not be_routable
  end

  it 'should not expose create route' do
    { :put => '/administrative_process_liberations/1' }.should_not be_routable
  end

  it 'should not expose destroy route' do
    { :delete => '/administrative_process_liberations/1' }.should_not be_routable
  end
end
