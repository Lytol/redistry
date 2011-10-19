require 'spec_helper'
require 'redistry/serializers/json'

describe Redistry::Serializers::JSON do
  before do
    @serializer = Redistry::Serializers::JSON.new
  end

  describe "#serialize" do
    context "with multiple objects" do
      it "should return JSON of each object" do
        objs = [{"brian" => "smith"}, {"lizzie" => "turner"}]
        expected_json = @serializer.serialize(Hash, objs)
        expected_json.should == objs.map { |o| o.to_json }
      end
    end

    context "with single object" do
      it "should return JSON of object in array" do
        obj = {"brian" => "smith"}
        expected_json = @serializer.serialize(Hash, obj)
        expected_json.should == [obj.to_json]
      end
    end
  end

  describe "#deserialize" do
    context "with multiple objects" do
      it "should return each object" do
        objs = [{"brian" => "smith"}, {"lizzie" => "turner"}]
        @serializer.deserialize(Hash, objs.map(&:to_json)).should == objs
      end
    end

    context "with single object" do
      it "should return object in array" do
        obj = {"brian" => "smith"}
        @serializer.deserialize(Hash, obj.to_json).should == [obj]
      end
    end
  end
end
