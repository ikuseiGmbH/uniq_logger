module UniqLogger
  class Base
    def initialize(opts={}, &block)
      Configuration.configure_with_path
    end

    def config
      Configuration.config
    end

    def create(uniq_id, data_to_save=[])
      if config["logfile_destination"] == "local"
        create_local_log_entry(uniq_id, data_to_save)
      elsif config["logfile_destination"] == "remote"
        create_remote_log_entry(uniq_id, data_to_save)
      else
        puts "logfile_destination is not set to [local,ftp]"
        return false
      end
    end


    def create_local_log_entry(uniq_id, data_to_save)
      #Use global Logger
      if config["global_logger"] == true
        raise "Directory of 'path_to_local_logfiles' '#{config["path_to_local_logfiles"]}' does not exist!" unless File.directory?(config["path_to_local_logfiles"])
        logfilename = File.join(config["path_to_local_logfiles"], config["global_log_file_name"])
        logfile = File.open( File.expand_path(logfilename), "a" )
        
        if is_uniq_id_in_log_hostory?(uniq_id,logfile)
          return false
        end
        
        #write Data to Logfile File
        logfile.puts [uniq_id,data_to_save].flatten.join(config["csv"]["col_sep"])
        logfile.close
      end

      #Use Log Rotator?
      if ['day','month','year'].include?(config["log_rotator"])
        logger_prefix = get_current_logger_prefix()
        rotator_logfilename = File.join(config["path_to_local_logfiles"], "#{config['log_rotator_prefix']}#{logger_prefix}.log")
        rotator_logfile = File.open( File.expand_path(rotator_logfilename), "a" )
        rotator_logfile.puts [uniq_id,data_to_save].flatten.join(config["csv"]["col_sep"])
        rotator_logfile.close
      end

      return true
    end


    def is_uniq_id_in_log_hostory?(uniq_id,logfile)
      if config["validates_uniqness_of_id"] == true
        data = CSV.read(logfile, {:col_sep => config["csv"]["col_sep"], :encoding => config["csv"]["encoding"] })
        list_of_ids = data.map{ |a| a[0]}
        #puts data
        if list_of_ids.include?(uniq_id)
          return true
        end
      end
      return false
    end

    def get_current_logger_prefix
      case config["log_rotator"]
        when "day"
          filename_prefix = Time.now.strftime("%d-%m-%Y")
        when "month"
          filename_prefix = Time.now.strftime("%m-%Y")
        when "year"
          filename_prefix = Time.now.strftime("%Y")
        else
          filename_prefix = ""
      end
      return filename_prefix
    end


    def create_remote_log_entry(uniq_id, data_to_save)
      begin
        auth_token = config["remote"]["auth_token"]
        server_name = config["remote"]["server"]
        endpoint = config["remote"]["endpoint"]
        param_id = config["remote"]["url_param_for_id"]
        param_data = config["remote"]["url_param_for_data"]

        uri = URI.parse("#{server_name}#{endpoint}?auth_token=#{auth_token}")

        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri)
        
        if !config["remote"]["basic_auth"]["username"].nil? && !config["remote"]["basic_auth"]["password"].nil? && !config["remote"]["basic_auth"]["username"].empty? && !config["remote"]["basic_auth"]["password"].empty?
         request.basic_auth(config["remote"]["basic_auth"]["username"], config["remote"]["basic_auth"]["password"])
        end
        
        request.form_data = { param_id.to_sym => uniq_id, param_data.to_sym => data_to_save.to_json }
        response = http.request(request)

        json = JSON.parse response.body
        if json['response'] == "true"
          return true
        else
          return false
        end
      rescue
        puts "Connetion to Server failed"
        return false
      end
    end
    
  end
end
