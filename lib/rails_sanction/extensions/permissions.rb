module RailsSanction
  module Extensions
    module Permissions
      extend ActiveSupport::Concern

      def path
        @path ||= predicates.map do |object|
          {
            predicate:  object,
            node:       @graph.find(object)
          }
        end.reject { |x| x[:node].blank? }
      end

    end
  end
end