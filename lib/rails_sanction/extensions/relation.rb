module RailsSanction
  module Extensions
    module Relation

      def permitted(perm)
        perm.permitted? ? including(perm.allowed_ids).excluding(perm.denied_ids) : none
      end

      def including(allowed_ids=[])
        if allowed_ids.any?
          where(id: allowed_ids) 
        else
          self
        end
      end

      def excluding(denied_ids=[])
        if denied_ids.any?
          where.not(id: denied_ids)
        else
          self
        end
      end
    end
  end
end