class SettingsUpdater
  attr_accessor :storage, :i18n

  def initialize(storage = Setting, i18n = I18n)
    self.storage = storage
    self.i18n = i18n
  end

  def update
    storage.transaction do
      i18n.translate(:settings).each_pair do |key, _|
        storage.find_or_create_by_key(key.to_s)
      end
    end
  end
end
