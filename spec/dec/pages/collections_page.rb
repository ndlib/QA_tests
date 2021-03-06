# frozen_string_literal: true

module Dec
  module Pages
    class CollectionsPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          valid_page_content?
      end

      def on_valid_url?
        # urls are in the format /somehash/some-hyphenated-words
        # we use a regex here to match that and return true
        str = Capybara.app_host + '/[A-z0-9]{10}/[A-Za-z0-9]+(?:-[A-Za-z0-9]+)*$'
        %r{#{str}}.match(current_url).is_a?(MatchData)
      end

      def valid_page_content?
        within('.brand-bar') do
          find('a', exact_text: 'UNIVERSITY of NOTRE DAME')
        end
        first('h1') &&
          first('span', text: 'arrow_forward') &&
          first('span', text: 'menu') &&
          first('span', text: 'search') &&
          !find_all('div.collection-site-path-card').empty?
      end

      def click_forward_arrow
        first('span', text: 'arrow_forward').click
      end
    end
  end
end
