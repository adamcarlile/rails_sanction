module RailsSanction
  module Sanctioned
    extend ActiveSupport::Concern

    included do |variable|
      before_save do
        self.permissions = permissions.to_hash
      end      
    end

    def permissions
      @permissions ||= Sanction.build(user_permissions)
    end

    def permissions=(value)
      @permissions = Sanction.build(value)
      super(value.to_hash)
    end

    def permitted
      permissions
    end

    def can?(role, *predicates)
      permission = Sanction.permission(permissions, *predicates)
      permission.permitted_with_scope?(role)
    end

    private

      def user_permissions
        (attributes['permissions'] || default_permissions).with_indifferent_access
      end

      def default_permissions
        RailsSanction.config.default_permissions_hash
      end
  end
end