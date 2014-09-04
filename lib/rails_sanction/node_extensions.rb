module RailsSanction
  module NodeExtensions
    extend ActiveSupport::Concern

    def method_missing(method, *args, &block)
      case
      when available_pluralised_models.include?(method) 
        RailsSanction::Resolvers::Query.new(self[method.to_s.singularize.to_sym]).resolve
      when available_models.include?(method)
        raise ArgumentError if args.blank?
        self[method][args.first]
      else
        super
      end
    end

    def subject
      RailsSanction::Resolvers::Model.new(self).resolve
    end

    def available_models
      @available_models ||= begin
        array = []
        walk do |child|
          array << child.type
        end
        array.uniq.compact
      end
    end

    def find(object)
      super(object.class.to_s.demodulize.downcase, object.id)
    end

    def change_type! type, object=nil
      if object
        find(object).change_type!(type)
      else
        change_type!(type)
      end
    end

    def available_pluralised_models
      available_models.map {|x| x.to_s.pluralize.to_sym }
    end

    def add_object(object, options={})
      @available_models = nil
      options.reverse_merge!({scope: [], mode: :blacklist})
      add_subject({
        id:   object.id,
        type: object.class.to_s.demodulize.downcase.to_sym
      }.merge(options))
    end

  end
end