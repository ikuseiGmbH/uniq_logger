module UniqLogger
  class Configuration
    @config = {
              :log_level => "verbose",
              :min => 0,
              :max => 99 
            }

    @valid_config_keys = @config.keys

    # Configure through hash
    def self.configure(opts = {})
      opts.each {|k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
    end

    # Configure through yaml file
    def self.configure_with_path
      path_to_yaml_file = "../config/uniq_logger.yml"
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
