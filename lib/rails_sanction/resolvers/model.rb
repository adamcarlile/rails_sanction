module RailsSanction
  module Resolvers
    class Model

      def initialize(permission)
        @permission = permission
      end

      def model
        @permission.type.to_s.classify.constantize
      end

      def resolve
        model.find(@permission.id)
      end

    end
  end
end