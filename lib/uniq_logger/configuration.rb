module UniqLogger
  class Configuration
    @config = {
              :log_rotator => "none",
              :log_rotator_prefix => "uniq_logger-",
              :global_logger => true,
              :global_log_file_name => "uniq_logger.log",
              :validates_uniqness_of_id => true,
              :logfile_destination => "local",
              :path_to_local_logfiles => "log",
              :remote => {
                :auth_token => "xyz123abc",
                :server => "http://www.server.de",
                :endpoint => "/api/v1/logger",
                :url_param_for_id => "id",
                :url_param_for_data => "data"
              },
              :csv => {
                :encoding => "UTF8",
                :col_sep => ";"
              }
            }

    @valid_config_keys = @config.keys

    # Configure through hash
    def self.configure(opts = {})
      opts.each {|k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
    end

    # Configure through yaml file
    def self.configure_with_path
      if defined?(::Rails).nil?
        path_to_yaml_file = "../config/uniq_logger.yml"
      else
        path_to_yaml_file = "#{::Rails.root}/config/uniq_logger.yml"
      end
      begin
        config = YAML::load(IO.read(path_to_yaml_file))
      rescue Errno::ENOENT
        puts "YAML configuration file couldn't be found. Using defaults."
        return
      rescue Psych::SyntaxError
        puts "YAML configuration file contains invalid syntax. Using defaults."
        return
      end

      configure(config)
    end

    def self.config
      @config
    end
  end
end
