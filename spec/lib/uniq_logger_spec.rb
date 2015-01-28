require 'spec_helper'
require 'uniq_logger'

describe UniqLogger do
  it 'has a version' do
    expect(UniqLogger::VERSION).to match(/\d+\.\d+\.\d+/)
  end
end

describe UniqLogger::Base do
  it 'can do something' do
    uniq_logger = UniqLogger::Base.new
  end
  
end