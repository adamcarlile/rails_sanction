module RailsSanction
  module Extensions
    module Controller
      extend ActiveSupport::Concern

      # sanctioned scope: [Bookcase.find(params[:bookcase])]

      def authorize! role, object
        predicates = self.class.sanction_scope
        predicates << object unless object.is_a? Class
        raise RailsSanction::Unauthorized unless current_user.can? role, predicates
      end

      module ClassMethods

        def sanctioned options={}
          options.reverse_merge!({
            scope: []
          })
          cattr_accessor :sanction_scope
          self.sanction_scope = options[:scope]
        end

      end

    end
  end
end