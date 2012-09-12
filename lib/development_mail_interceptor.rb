class DevelopmentMailInterceptor                                                                                             
  def self.delivering_email(message)
    message.subject = "[#{message.to}] #{message.subject}"
    message.to = `git config --global user.email`.strip
  end
end
