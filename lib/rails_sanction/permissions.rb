module RailsSanction
  class Permissions

    def initialize(permissions)
      @permissions = permissions
    end

    def method_missing(method, *args, &block)
      case
      when @permissions.available_pluralised_models.include?(method) 
        self.class.new(@permissions[method.to_s.singularize.to_sym])
      when @permissions.available_models.include?(method) && args.any?
        self.class.new(@permissions[method][args.first])
      else
        super
      end
    end

  end
end