require 'model_helper'
require 'app/models/extended_prefecture'

describe ExtendedPrefecture do
  it { should belong_to(:prefecture) }

  it { should validate_presence_of :prefecture }
end
