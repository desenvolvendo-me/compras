require 'model_helper'
require 'app/models/process_responsible'

describe ProcessResponsible do
  it { should belong_to :stage_process }
  it { should belong_to :licitation_process }
  it { should belong_to :employee }

  it { should validate_presence_of :stage_process }
  it { should validate_presence_of :licitation_process }
end
