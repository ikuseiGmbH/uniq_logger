require 'csv'
require 'yaml'
require 'net/http'
require 'uri'
require 'json'
require "uniq_logger/configuration"
require "uniq_logger/version"

module UniqLogger
  
  def self.new
    UniqLogger::Base.new
  end

end


require 'uniq_logger/base'