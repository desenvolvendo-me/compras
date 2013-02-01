require 'model_helper'
require 'app/models/setting'

describe Setting do
  it { should belong_to :prefecture }

  it { should validate_presence_of :prefecture }
end
