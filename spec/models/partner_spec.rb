require 'model_helper'
require 'app/models/persona/partner'
require 'app/models/extended_partner'
require 'app/models/partner'

describe Partner do
  it { should have_one(:extended_partner).dependent(:destroy) }

  it { should delegate(:society_kind).to(:extended_partner).allowing_nil(true) }
  it { should delegate(:society_kind_humanize).to(:extended_partner).allowing_nil(true) }
end
