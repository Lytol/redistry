require 'spec_helper'

class Stubba
  include Redistry::HasList

  has_list :list
end

describe Redistry::HasList do
  let(:klass) { Stubba }

  describe "#list" do
    describe "#key" do
      it "should be <class>-<list_name>" do
        klass.list.key.should == "#{klass.name}-list"
      end
    end

    describe "#all" do
      context "when empty" do

      end

      context "when not empty" do

      end
    end

    describe "#add" do
      context "with one obj" do
        it "should serialize obj"
        it "should left push obj onto Redis list"
      end

      context "with multiple objs" do
        it "should serialize each obj"
        it "should left push each obj onto Redis list"
      end
    end

    describe "#clear" do
      it "should call DEL on Redis key" do
        Redistry.client.should_receive(:del).with(klass.list.key)
        klass.list.clear
      end
    end
  end
end
