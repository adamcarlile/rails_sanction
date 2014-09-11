module RailsSanction
  module Extensions
    module Node
      extend ActiveSupport::Concern

      def method_missing(method, *args, &block)
        case
        when available_pluralised_models.include?(method) 
          self[method.to_s.singularize.to_sym]
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
        @available_models ||= ActiveRecord::Base.connection.tables.map(&:singularize).map(&:to_sym)
      end

      def find(object)
        super(object.class.to_s.demodulize.downcase, object.id)
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
end