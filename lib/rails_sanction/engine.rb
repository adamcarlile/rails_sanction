require 'rails_sanction'
require 'rails'

module RailsSanction
  class Engine < Rails::Engine
    engine_name 'rails_sanction'

    config.to_prepare do
      Sanction::Node.send(:prepend, RailsSanction::NodeExtensions)
    end

  end
end