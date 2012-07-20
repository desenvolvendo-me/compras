# encoding: utf-8
# load unit helper
require 'unit_helper'

# load decore
require 'decore'
require 'decore/proxy'

# load action view helpers
require 'active_support/concern'

require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/hash/reverse_merge'

require 'active_support/core_ext/string/access'

require 'action_view/helpers/capture_helper'
require 'action_view/helpers/number_helper'
require 'action_view/helpers/url_helper'
require 'action_view/helpers/translation_helper'

# i18n
require 'i18n'

I18n.backend.store_translations 'pt-BR', :number => {
  :format => {
    :separator => ",",
    :delimiter => ".",
    :precision => 2,
    :significant => false,
    :strip_insignificant_zeros => false
  },

  :currency => {
    :format => {
      :unit => "R$",
      :format => "%u %n"
    }
  }
}

I18n.backend.store_translations 'pt-BR', :support => {
  :array => {
    :two_words_connector => ' e '
  }
}

I18n.backend.store_translations 'pt-BR', :time => {
  :formats => {
    :hour => '%H:%M'
  }
}

I18n.backend.store_translations 'pt-BR', :date => {
  :formats => {
    :default => '%d/%m/%Y'
  }
}

I18n.default_locale = 'pt-BR'

# load decorator example group
require 'support/decorator_example_group'
