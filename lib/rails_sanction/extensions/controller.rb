module RailsSanction
  module Extensions
    module Controller
      extend ActiveSupport::Concern

      # sanctioned scope: -> { [Bookcase.find(params[:bookcase])] }

      def authorize! role, object
        predicates = [self.class.sanction_scope.call].flatten.compact
        predicates << object unless object.is_a? Class
        raise RailsSanction::Exceptions::Unauthorized unless current_user.can? role, *predicates
      end

      def permissions
        if self.class.sanction_scope.call
          current_user.permissions.find(self.class.sanction_scope.call)
        else
          current_user.permissions
        end
      end

      module ClassMethods

        def sanctioned options={}
          options.reverse_merge!({
            scope: -> {}
          })
          cattr_accessor :sanction_scope
          self.sanction_scope = options[:scope]
        end

      end

    end
  end
end