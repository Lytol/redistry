require 'spec_helper'

describe Redistry do
  it "should have VERSION" do
    Redistry::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end
end

