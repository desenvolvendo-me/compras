require 'unit_helper'
require 'active_model'
require 'active_relatus'


# I18n
require 'i18n'

I18n.load_path += Dir['config/locales/*.yml']
I18n.default_locale = 'pt-BR'

# I18n::Alchemy
require 'i18n_alchemy'

require 'app/reports/report'
