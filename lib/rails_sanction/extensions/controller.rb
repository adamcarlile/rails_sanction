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
        @permission_predicates ||= begin
          predicates = []
          predicates += self.class.sanction_scope.call(params).flatten.compact if self.class.sanction_scope.call(params).any? 
          predicates
        end
      end


      module ClassMethods

        def sanctioned options={}
          options.reverse_merge!({
            scope: ->(params={}) {[]}
          })
          cattr_accessor :sanction_scope
          self.sanction_scope = options[:scope]
        end

      end

    end
  end
end