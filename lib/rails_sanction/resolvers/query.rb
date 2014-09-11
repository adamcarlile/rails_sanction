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
        query = model.all
        query = query.where(id: @permission.allowed_ids) if @permission.allowed_ids.any?
        query = query.where.not(id: @permission.denied_ids) if @permission.denied_ids.any?
        query
      end

    end
  end
end