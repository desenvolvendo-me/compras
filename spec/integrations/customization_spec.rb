# encoding: utf-8
require 'spec_helper'

describe Customization do
  before { Customization.make!(:campo_string) }

  it { should validate_uniqueness_of(:model).scoped_to(:state_id).with_message('já existe para a Estado selecionado') }
end
