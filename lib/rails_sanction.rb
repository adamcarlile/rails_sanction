require 'active_support'
require 'active_support/core_ext'
require 'sanction'

require 'rails_sanction/resolvers/query'
require 'rails_sanction/resolvers/model'
require 'rails_sanction/permissions'
require 'rails_sanction/sanctioned'
require "rails_sanction/node_extensions"
require "rails_sanction/version"

require 'rails_sanction/engine' if defined? Rails

module RailsSanction
  
  module_function

  def config
    @config ||= ActiveSupport::OrderedOptions.new.tap do |x|
      x.user_model               = User
      x.storage_column           = :permissions
      x.default_permissions_hash = {
        mode:     :whitelist,
        scope:    [:read],
        subjects: []
      }
    end
  end

  def configure(&block)
    yield(config)
  end

end
