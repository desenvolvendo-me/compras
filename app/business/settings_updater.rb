class SettingsUpdater
  attr_accessor :repository, :i18n

  def initialize(repository = Setting, i18n = I18n)
    self.repository = repository
    self.i18n = i18n
  end

  def update
    repository.transaction do
      i18n.translate(:settings).each_pair do |key, _|
        repository.find_or_create_by_key(key.to_s)
      end
    end
  end
end
