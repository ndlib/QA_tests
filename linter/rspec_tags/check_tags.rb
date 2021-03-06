# frozen_string_literal: true

# @see https://downey.io/blog/writing-rubocop-linters-for-database-migrations/ for background in creating
# and implementing custom Rubocop linters
#
# @see http://www.rubydoc.info/gems/rubocop/RuboCop/AST to learn about methods for using Rubocop Node Pattern
module RuboCop
  module Cop
    module RSpecTags
      class CheckTags < RuboCop::Cop::Cop
        # This cop checks for :nonprod_only and :read_only RSpec tags on scenario lines.
        # Each scenario must have at least one of these tags to discern which scenarios
        # should be run on prod which ones should not be run on prod.
        #
        # @example
        #    # bad
        #    scenario "jello" do
        #
        # @example
        #    # good
        #    scenario "jello", :read_only do
        #
        # @example
        #    # good
        #    scenario "jello", :nonprod_only do
        MSG = 'All scenarios must either have a :nonprod_only or a :read_only tag. Further details see: https://github.com/ndlib/QA_tests#tagging'

        def on_block(node)
          node.each_descendant(:send) do |send_node|
            method = send_node.method_name
            next unless scenario?(method)

            opts = send_node.child_nodes
            add_offense(send_node, :expression, format(MSG, send_node.type)) unless tags?(opts)
          end
        end

        def method_name(node)
          node.child_nodes[1]
        end

        def scenario?(method)
          method == :scenario
        end

        def tags?(opts)
          opts.each do |child|
            if child.type == :sym && (child.children[0] == :read_only || child.children[0] == :nonprod_only)
              return true
            end
          end
        end
      end
    end
  end
end
