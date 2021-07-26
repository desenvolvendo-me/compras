require 'spec_helper'

describe MenuHelper do
  describe "#render_menu" do
    before do
      helper.stub_chain(:current_user, :administrator?).and_return(false)
    end

    it "should render the menu" do
      helper.should_receive(:can?).any_number_of_times.with(any_args).and_return(true)

      helper.should_receive(:item1_path).and_return('/item_um')
      helper.should_receive(:item2_path).and_return('/item_dois')

      I18n.should_receive(:t).with('menu.main_menu').and_return('Menu Principal')
      I18n.should_receive(:t).with('menu.submenu').and_return('Submenu')
      I18n.should_receive(:t).with('menu.item1').and_return('Item 1')
      I18n.should_receive(:t).with('menu.item2').and_return('Item 2')

      expect(helper.render_menu(:path => 'spec/fixtures/menu.yml')).to eq '<li><a href="#">Menu Principal</a><ul><li><a href="#">Submenu</a><ul><li><a href="/item_um">Item 1</a></li><li><a href="/item_dois">Item 2</a></li></ul></li></ul></li>'
    end

    it 'should not render the menu' do
      helper.should_receive(:can?).any_number_of_times.with(any_args).and_return(false)

      expect(helper.render_menu(:path => 'spec/fixtures/menu.yml')).to eq ''
    end
  end
end
