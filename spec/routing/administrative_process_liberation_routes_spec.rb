require 'spec_helper'

describe "routing to administrative_process_liberation" do
  it 'should not expose index route' do
    expect( { :get => '/administrative_process_liberations' } ).not_to be_routable
  end

  it 'should not expose create route' do
    expect( { :put => '/administrative_process_liberations/1' } ).not_to be_routable
  end

  it 'should not expose destroy route' do
    expect( { :delete => '/administrative_process_liberations/1' } ).not_to be_routable
  end
end
