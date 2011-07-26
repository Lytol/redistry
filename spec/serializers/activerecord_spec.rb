require 'spec_helper'

class ARStub
  attr_accessor :id

  def initialize(id)
    self.id = id
  end
end

describe Redistry::Serializers::ActiveRecord do
  let(:serializer) { Redistry::Serializers::ActiveRecord.new }

  describe "#serialize" do
    context "with single object" do
      before do
        @obj = ARStub.new(1)
      end

      it "should return id in array" do
        serializer.serialize(ARStub, @obj).should == [1]
      end
    end

    context "with array" do
      before do
        @objs = (1..5).map { |i| ARStub.new(i) }
      end

      it "should return ids" do
        serializer.serialize(ARStub, @objs).should == [1,2,3,4,5]
      end
    end

    context "with list of args" do
      before do
        @objs = (1..5).map { |i| ARStub.new(i) }
      end

      it "should return ids" do
        serializer.serialize(ARStub, *@objs).should == [1,2,3,4,5]
      end
    end
  end

  describe "#deserialize" do
    context "with single id" do
      it "should call klass.find with the id in an array" do
        @obj = ARStub.new(1)
        ARStub.should_receive(:find).with([1]).and_return([@obj])
        serializer.deserialize(ARStub, 1).should == [@obj]
      end
    end

    context "with array of ids" do
      it "should call klass.find with the ids" do
        @objs = (1..5).map { |i| ARStub.new(i) }
        ARStub.should_receive(:find).with([1,2,3,4,5]).and_return(@objs)
        serializer.deserialize(ARStub, [1,2,3,4,5]).should == @objs
      end
    end

    context "with ids as arguments" do
      it "should call klass.find with the ids" do
        @objs = (1..5).map { |i| ARStub.new(i) }
        ARStub.should_receive(:find).with([1,2,3,4,5]).and_return(@objs)
        serializer.deserialize(ARStub,1,2,3,4,5).should == @objs
      end
    end
  end
end
