module RailsSanction
  module Extensions
    module Relation

      def permitted(perm)
        if perm.permitted?
          return self if perm.wildcarded?
          including(perm.allowed_ids).excluding(perm.denied_ids)
        else
          none
        end
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