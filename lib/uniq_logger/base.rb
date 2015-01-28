module UniqLogger
  class Base
    def initialize(opts={}, &block)
      Configuration.configure_with_path
    end

    def config
      Configuration.config
    end

    def create(uniq_id, data_to_save=[])
      if config[:logfile_destination] == "local"
        create_local_log_entry(uniq_id, data_to_save)
      elsif config[:logfile_destination] == "ftp"
        create_ftp_log_entry(uniq_id, data_to_save)
      else
        puts "logfile_destination is not set to [local,ftp]"
        return false
      end
    end


    def create_local_log_entry(uniq_id, data_to_save)
      #Use global Logger
      if config[:global_logger] == true
        raise "Directory of 'path_to_local_logfiles' '#{config[:path_to_local_logfiles]}' does not exist!" unless File.directory?(config[:path_to_local_logfiles])
        logfilename = File.join(config[:path_to_local_logfiles], config[:global_log_file_name])
        logfile = File.open( File.expand_path(logfilename), "a" )
        
        if is_uniq_id_in_log_hostory?(uniq_id,logfile)
          return false
        end
        
        #write Data to Logfile File
        logfile.puts [uniq_id,data_to_save].flatten.join(config[:csv][:col_sep])
        logfile.close
      end

      #Use Log Rotator?
      if ['day','month','year'].include?(config[:global_logger])
        logger_prefix = get_current_logger_prefix()
        rotator_logfilename = File.join(config[:path_to_local_logfiles], "#{config[:log_rotator_prefix]}#{logger_prefix}.log")
        rotator_logfile = File.open( File.expand_path(rotator_logfilename), "a" )
        rotator_logfile.puts [uniq_id,data_to_save].flatten.join(config[:csv][:col_sep])
        rotator_logfile.close
      end

      return true
    end


    def is_uniq_id_in_log_hostory?(uniq_id,logfile)
      if config[:validates_uniqness_of_id] == true
        data = CSV.read(logfile, {:col_sep => config[:csv][:col_sep], :encoding => config[:csv][:encoding] })
        list_of_ids = data.map{ |a| a[0]}
        #puts data
        if list_of_ids.include?(uniq_id)
          return true
        end
      end
      return false
    end

    def get_current_logger_prefix
      case config[:global_logger]
        when "day"
          filename_prefix = Time.now.strftime("%d-%m-%y")
        when "month"
          filename_prefix = Time.now.strftime("%m-%y")
        when "year"
          filename_prefix = Time.now.strftime("%y")
        else
          filename_prefix = ""
      end
      return filename_prefix
    end


    def create_ftp_log_entry(uniq_id, data_to_save)
      
    end
    
  end
end
