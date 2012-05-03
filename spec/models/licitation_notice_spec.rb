require 'model_helper'
require 'app/models/licitation_notice'

describe LicitationNotice do
  it { should belong_to :licitation_process }

  it { should validate_presence_of :licitation_process }
  it { should validate_presence_of :date }
  it { should validate_presence_of :number }
end
