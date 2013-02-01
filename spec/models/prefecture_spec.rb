require 'model_helper'
require 'app/uploaders/image_uploader'
require 'app/models/unico/prefecture'
require 'app/models/prefecture'
require 'app/models/setting'

describe Prefecture do
  it { should have_one(:setting).dependent(:destroy) }
end
