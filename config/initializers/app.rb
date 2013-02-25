require 'minimapper/repository'
require File.join(Rails.root, 'config/repositories')

class App
  class << self
    attr_accessor :repository
  end

  def self.reset_repository
    self.repository = Repositories::AR
  end

  def self.api_token
    if Rails.env.test? || Rails.env.development?
      'test-api-token'
    else
      ENV['API_TOKEN'] || raise("Missing API_TOKEN")
    end
  end

  def self.builds_to_keep
    (ENV['BUILDS_TO_KEEP'] || 1000).to_i
  end

  reset_repository
end
