module RailsSanction
  module Extensions
    module Controller
      extend ActiveSupport::Concern

      # sanctioned scope: -> { [Bookcase.find(params[:bookcase])] }
      included do
        helper_method :permissions
      end

      def authorize! role, object=nil
        predicates =  permission_predicates.dup
        predicates << object if object
        raise RailsSanction::Exceptions::Unauthorized unless current_user.can? role, *predicates.compact
      end

      def permissions
        Sanction::Permission.new(current_user.permissions, *permission_predicates).path
      end

      def permission_predicates
        @permission_predicates ||= (instance_sanction_scope || [])
      end

      def instance_sanction_scope
        @instance_sanction_scope ||= [instance_eval(&self.class.sanction_scope)].flatten.compact
      end

      def add_permission_for object
        perm = current_user.permissions.path.last
        perm.add_object(shelf) if perm.whitelist?
        true
      end


      module ClassMethods

        def sanctioned options={}
          options.reverse_merge!({
            scope: ->(controller) {[]}
          })
          cattr_accessor :sanction_scope
          self.sanction_scope = options[:scope]
        end

      end

    end
  end
end
