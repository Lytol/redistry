require 'spec_helper'

class StubNoId
  include Redistry::List
end

class StubWithId
  include Redistry::List
  attr_accessor :id
  def initialize(id)
    @id = id
  end
end

describe "#has_list" do
  context "with class without id" do
    let(:klass) { StubNoId }
    let(:instance) { klass.new }

    before do
      klass.has_list(:items, :class => StubNoId)
    end

    it "should raise error" do
      lambda {
        instance.items.key
      }.should raise_error
    end
  end

  context "with valid class" do
    let(:klass) { StubWithId }
    let(:instance) { klass.new(1) }

    before do
      klass.has_list(:items, :class => StubWithId)
    end

    it "should have key with id" do
      instance.items.key.should == "#{klass.name}-items-1"
    end
  end
end
