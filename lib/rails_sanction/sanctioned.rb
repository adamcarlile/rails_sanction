module RailsSanction
  module Sanctioned
    extend ActiveSupport::Concern

    included do
      before_save do
        self.send("#{RailsSanction.config.storage_column}=", send(RailsSanction.config.storage_column).to_hash)
      end

      define_method RailsSanction.config.storage_column do
        if instance_variable_get("@#{RailsSanction.config.storage_column}")
          instance_variable_get("@#{RailsSanction.config.storage_column}")
        else
          instance_variable_set("@#{RailsSanction.config.storage_column}", Sanction.build(user_permissions))
        end
      end
    end

    def permitted
      send(RailsSanction.config.storage_column)
    end

    def can? role, *predicates
      permission = Sanction::Permission.new(send(RailsSanction.config.storage_column), *predicates)
      permission.permitted_with_scope?(role)
    end

    private

      def user_permissions
        (attributes[RailsSanction.config.storage_column.to_s] || default_permissions).with_indifferent_access
      end

      def default_permissions
        RailsSanction.config.default_permissions_hash
      end
  end
end