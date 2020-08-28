require 'unit_helper'

# ActiveRecord
require 'active_record'

spec = YAML.load(ERB.new(File.read('config/database.yml')).result)
ActiveRecord::Base.establish_connection(spec['test'])

# Squeel
require 'squeel'

# Shoulda Matchers
require 'shoulda-matchers'
require 'spec/support/sequence_generator_matcher'
require 'spec/support/validate_duplication_of_matcher'
require 'spec/support/delegate_matcher'

# ActiveRecord::Filter
require 'lib/active_record/filters/base'
require 'lib/active_record/filters/filter'
require 'lib/active_record/filter'
require 'lib/active_record/block'

class ActiveRecord::Base
  include ActiveRecord::Filter
end

# ActiveRecord::Modal
require 'lib/active_record/modal'

class ActiveRecord::Base
  include ActiveRecord::Modal
end

require 'lib/sequence_generator'

class ActiveRecord::Base
  include SequenceGenerator
end

# Validations
require 'cnpj_validator'
require 'cpf_validator'
require 'mail_validator'
require 'mask_validator'
require 'validates_timeliness'

ValidatesTimeliness.setup do |config|
  config.ignore_restriction_errors = true
end

Dir['app/validators/*.rb'].each do |file|
  require File.expand_path(file)
end

# AwesomeNestedNet
require 'awesome_nested_set'

# CarrierWave
require 'carrierwave'
require 'carrierwave/orm/activerecord'

# Devise
require 'devise'
require 'devise/orm/active_record'

# I18n
require 'i18n'

I18n.load_path += Dir['config/locales/*.yml']
I18n.default_locale = 'pt-BR'

# I18n::Alchemy
require 'i18n_alchemy'

class ActiveRecord::Base
  include I18n::Alchemy
end

Dir['app/parsers/*.rb'].each do |file|
  require File.expand_path(file)
end

# Unico
require 'unico/engine'
require 'unico/model'
require 'unico-api'
require 'persona'
require 'inscriptio_cursualis'

# EnumerateIt
require 'enumerate_it'

class ActiveRecord::Base
  extend EnumerateIt
end

Dir['app/enumerations/*.rb'].each do |file|
  require File.expand_path(file)
end

# Compras Model
require 'compras'
require 'accounting'

# Financeiro Model
require 'financeiro'

$:.append Unico::Engine.config.root

# uploaders
require 'app/uploaders/uploader'
require 'app/uploaders/unico_uploader'
require 'app/uploaders/compras_uploader'
require 'app/uploaders/image_uploader'
require 'app/uploaders/prefecture_logo_uploader'
require 'app/uploaders/attachment_uploader'
require 'app/uploaders/individual_image_uploader'

Dir["#{Unico::Engine.config.root}/app/enumerations/*.rb"].each do |file|
  require File.expand_path(file)
end

# Custom Data
require 'lib/custom_data'
require 'app/models/unico/prefecture'
require 'app/models/prefecture'

require 'activerecord-postgres-hstore'

require 'lib/active_resource/parser'
require 'lib/active_resource/reflection'
require 'lib/active_resource/associations'
require 'lib/belongs_to_resource'
require 'lib/consumer'
