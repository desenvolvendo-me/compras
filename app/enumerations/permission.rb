class Permission < EnumerateIt::Base
  associate_values :deny, :read, :modify, :access

  def self.ordered
    {
        I18n.t('enumerations.permission.deny') => :deny,
        I18n.t('enumerations.permission.read') => :read,
        I18n.t('enumerations.permission.modify') => :modify,
        I18n.t('enumerations.permission.access') => :access
    }
  end
end
