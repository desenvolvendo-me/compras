require 'model_helper'
require 'app/models/role'

describe Role do
  it { should belong_to :profile }

  it { should validate_presence_of :profile }
  it { should validate_presence_of :controller }
  it { should validate_presence_of :permission }

end
