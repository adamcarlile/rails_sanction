module RailsSanction
  module Resolvers
    class Query

      def initialize(permission)
        @permission = permission
      end

      def model
        @permission.type.to_s.classify.constantize
      end

      def resolve
        model.where(id: @permission.allowed_ids).where.not(id: @permission.denied_ids)
      end

    end
  end
end