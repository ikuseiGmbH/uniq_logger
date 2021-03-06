require 'spec_helper'
require 'uniq_logger'

describe UniqLogger do
  it 'has a version' do
    expect(UniqLogger::VERSION).to match(/\d+\.\d+\.\d+/)
  end
end

describe UniqLogger::Base do
  before(:each) do
    @logger = UniqLogger.new
    @logger.config["global_log_file_name"] = "rspec_logger.log"
    #reset local Logfile
    @logfilename = File.join(@logger.config["path_to_local_logfiles"], @logger.config["global_log_file_name"])
    if File.exists?(@logfilename)
      File.delete( File.expand_path(@logfilename) )
    end
  end

  it 'has a valid configuration' do
    expect(@logger.config["log_rotator"]).to eq("none")
    expect(@logger.config["global_logger"]).to eq(true)
    expect(@logger.config["csv"]["encoding"]).to eq("UTF8")
    expect(@logger.config["csv"]["col_sep"]).to eq(";")
    expect(@logger.config["logfile_destination"]).to eq("local")
  end
  
  it 'should write a log to a logfile with validation of ID true' do
    expect(@logger.create("12343", ["Vorname", "12344", "Strasse"])).to eq(true)
    expect(@logger.create("12344", ["Vorname", "12343", "Strasse"])).to eq(true)
    expect(@logger.create("12345", ["Vorname", "Nachname", "Strasse"])).to eq(true)
    expect(@logger.create("12346", ["Vorname2", "Nachname2", "Strasse2"])).to eq(true)
    expect(@logger.create("12346", ["Vorname3", "Nachname3", "Strasse3"])).to eq(false)
  end

  it 'should write a log to a logfile with validation of ID false' do
    @logger.config["validates_uniqness_of_id"] = false
    expect(@logger.create("12345", ["Vorname", "Nachname", "Strasse"])).to eq(true)
    expect(@logger.create("12346", ["Vorname2", "Nachname2", "Strasse2"])).to eq(true)
    expect(@logger.create("12346", ["Vorname3", "Nachname3", "Strasse3"])).to eq(true)
  end

  it 'should write a log rotator to a logfile per day' do
    @logger.config["log_rotator"] = "day"
    expect(@logger.create("12345", ["Vorname", "Nachname", "Strasse"])).to eq(true)
    expect(@logger.create("12346", ["Vorname2", "Nachname2", "Strasse2"])).to eq(true)
    expect(@logger.create("12346", ["Vorname3", "Nachname3", "Strasse3"])).to eq(true)
  end

  it 'should write a log rotator to a logfile per month' do
    @logger.config["log_rotator"] = "month"
    expect(@logger.create("12345", ["Vorname", "Nachname", "Strasse"])).to eq(true)
    expect(@logger.create("12346", ["Vorname2", "Nachname2", "Strasse2"])).to eq(true)
    expect(@logger.create("12346", ["Vorname3", "Nachname3", "Strasse3"])).to eq(true)
  end

  it 'should write a log rotator to a logfile per year' do
    @logger.config["log_rotator"] = "year"
    expect(@logger.create("12345", ["Vorname", "Nachname", "Strasse"])).to eq(true)
    expect(@logger.create("12346", ["Vorname2", "Nachname2", "Strasse2"])).to eq(true)
    expect(@logger.create("12346", ["Vorname3", "Nachname3", "Strasse3"])).to eq(true)
  end

  it 'sould send data to remote api' do
    @logger.config["logfile_destination"] = "remote"
    @logger.config["remote"]["auth_token"] = "QviQAtx1mq1ZCWC12RUy"
    @logger.config["remote"]["server"] = "http://localhost:3000"
    @logger.config["remote"]["endpoint"] = "/crm/api/v1/loggers.json"
    expect(@logger.create("1112", ["Remote", "Server", "Strasse3"])).to eq(true)
  end


end