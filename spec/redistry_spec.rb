require 'spec_helper'

describe Redistry do
  it "should have VERSION" do
    Redistry::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end

  it "should have default client" do
    Redistry.client.class.should == Redis
  end
end
