require 'unit_helper'
require 'active_model'
require 'active_relatus'
require 'enumerate_it'

# Date helpers
require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/time/calculations'

# I18n
require 'i18n'
require 'i18n_alchemy'

I18n.load_path += Dir['config/locales/*.yml']
I18n.default_locale = 'pt-BR'

require 'app/reports/report'
require 'app/reports/concerns/start_end_dates_range'
require 'shoulda-matchers'
