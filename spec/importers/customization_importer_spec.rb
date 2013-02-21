# encoding: utf-8
require 'spec_helper'

describe CustomizationImporter do
  it 'imports customizations' do
    expect do
      subject.import!("MG")
    end.to change(Customization, :count)
  end

  it 'imports customization_data' do
    expect do
      subject.import!("MG")
    end.to change(CustomizationData, :count)
  end

  it 'imports only customizations for specified state' do
    expect do
      subject.import!("NY")
    end.not_to change(CustomizationData, :count)
  end
end
