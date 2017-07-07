# frozen_string_literal: true
module WebRenovation
  module Pages
    # /personal
    class HeaderAllChecks < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
        correct_content?
      end

      def correct_content?
        within('.uNavigation') do
          find_by_id('research').trigger('click')
        end
        within('.menu-drawer.visible') do
          find('.more').trigger('click')
          last_opened_window = page.driver.browser.window_handles.last
          page.driver.browser.switch_to_window(last_opened_window)
          current_url == (Capybara.app_host + 'research')
        end
        within('.uNavigation') do
          find_by_id('services').trigger('click')
        end
        within('.menu-drawer.visible') do
          find('.more').trigger('click')
          last_opened_window = page.driver.browser.window_handles.last
          page.driver.browser.switch_to_window(last_opened_window)
          current_url == (Capybara.app_host + 'services')
        end
      end
    end
  end
end