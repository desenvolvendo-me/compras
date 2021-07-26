require 'unit_helper'
require 'i18n'
require 'active_support/core_ext/string/inflections'
require 'enumerate_it'

I18n.load_path = Dir['config/locales/*.yml']
I18n.default_locale = 'pt-BR'
