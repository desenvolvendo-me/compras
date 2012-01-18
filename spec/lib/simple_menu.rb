require 'unit_helper'

require 'lib/simple_menu'
require 'lib/simple_menu/item'

# ActionView::Helpers::TagHelper and ActionView::Helpers::UrlHelper
# See https://github.com/rails/rails/issues/3944
require 'active_support/concern'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/string/encoding'
require 'action_view/buffers'
require 'action_view/helpers/capture_helper'

require 'action_view/helpers/tag_helper'
require 'action_view/helpers/url_helper'

# Capybara matchers
require 'capybara/rspec'

describe SimpleMenu, :type => :acceptance do
  subject do
    SimpleMenu.new(template) do |m|
      m.authorized_controller
      m.unauthorized_controller
    end
  end

  let :template do
    Class.new do
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::UrlHelper

      attr_accessor :output_buffer
    end.new
  end

  let :menu do
    subject.render
  end

  before do
    template.stub!(:can?).with(:read, :authorized_controller).and_return(true)
    template.stub!(:can?).with(:read, :unauthorized_controller).and_return(false)

    template.stub!(:url_for).with(:authorized_controller).and_return('/authorized_controller')
    template.stub!(:url_for).with(:unauthorized_controller).and_return('/unauthorized_controller')

    template.stub!(:translate).with(:authorized_controller, :scope => :controllers).and_return('Authorized Controller')
    template.stub!(:translate).with(:unauthorized_controller, :scope => :controllers).and_return('Unauthorized Controller')
  end

  it 'render authorized links' do
    menu.should have_link('Authorized Controller', :href => "/authorized_controller")
  end

  it 'do not render unauthorized links' do
    menu.should_not have_link('Unauthorized Controller', :href => "/unauthorized_controller")
  end
end
