require 'rails_sanction'
require 'rails'

module RailsSanction
  class Engine < Rails::Engine
    engine_name 'rails_sanction'

    config.to_prepare do
      Sanction::Node.send(:prepend, RailsSanction::Extensions::Node)
      Sanction::Permission.send(:prepend, RailsSanction::Extensions::Permissions)
      ActionController::Base.send(:include, RailsSanction::Extensions::Controller)
    end

  end
end