module RSpec
  module Core
    class Example
      def set_exception(exception, context=nil)
        if @exception
          # An error has already been set; we don't want to override it,
          # but we also don't want silence the error, so let's print it.
          msg = <<-EOS

  An error occurred #{context}
    #{exception.class}: #{exception.message}
    occurred at #{exception.backtrace.first}

          EOS
          RSpec.configuration.reporter.message(msg)
        end

        @exception ||= exception

        screenshot if screenshot_on_errors? && is_metadata_type_request?
      end

      private

      def is_metadata_type_request?
        @metadata[:type] == :request
      end

      def screenshot_full_path
        p = Pathname.new(screenshot_folder).join(screenshot_name)
        p.to_path
      end

      def screenshot_name
        "error_#{next_error_number}.png"
      end

      def next_error_number
        images_path = Pathname.new(screenshot_folder).join('*.png').to_path

        Dir.glob(images_path).size + 1
      end

      def screenshot_folder
        RSpec.configuration.screenshot_folder
      end

      def full_screenshot?
        RSpec.configuration.screenshot_full
      end

      def screenshot_on_errors?
        RSpec.configuration.screenshot_on_errors
      end

      def screenshot
        Capybara.current_session.driver.render(screenshot_full_path, :full => full_screenshot?)
      end
    end
  end
end

RSpec.configure do |config|
  config.add_setting :screenshot_folder, :default => 'tmp/errors'
  config.add_setting :screenshot_on_errors, :default => ENV['SCREENSHOT']
  config.add_setting :screenshot_full, :default => true
  config.add_setting :clear_screenshots_before_run, :default => true

  config.before(:suite) do
    if RSpec.configuration.screenshot_on_errors && RSpec.configuration.clear_screenshots_before_run
      FileUtils.rm_rf RSpec.configuration.screenshot_folder
      FileUtils.mkdir_p RSpec.configuration.screenshot_folder
    end
  end
end
