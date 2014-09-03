module RailsSanction
  class SanctionProxy < SimpleDelegator

    def available_models
      @available_models ||= begin
        array = []
        original_permissions.walk do |child|
          array << child.type
        end
        array.uniq.compact
      end
    end

    def find(object)
      original_permissions.find(object.class.to_s.demodulize.downcase, object.id)
    end

    def change_type! type, object=nil
      if object
        __setobj__ find(object).change_type!(type)
      else
        __setobj__ original_permissions.change_type!(type)
      end
    end

    def available_pluralised_models
      available_models.map {|x| x.to_s.pluralize.to_sym }
    end

    def add_subject(object, options={})
      @available_models = nil
      options.reverse_merge!({scope: [], mode: :blacklist})
      original_permissions.add_subject({
        id:   object.id,
        type: object.class.to_s.demodulize.downcase.to_sym
      }.merge(options))
    end

    private

      def original_permissions
        __getobj__
      end

  end
end