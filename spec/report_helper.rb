require 'unit_helper'
require 'active_model'
require 'active_relatus'

# I18n
require 'i18n'

I18n.load_path += Dir['config/locales/*.yml']
I18n.default_locale = 'pt-BR'

require 'app/reports/report'
require 'shoulda-matchers'
