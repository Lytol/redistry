require 'spec_helper'

class Stubba
  include Redistry::HasList
end

describe Redistry::HasList do
  let(:klass) { Stubba }

  context "without specified class" do
    before do
      klass.send(:has_list, :list)
    end

    describe "#list" do

      describe "#klass" do
        it "should be parent class" do
          klass.list.klass.should == klass
        end
      end

      describe "#key" do
        it "should be <class>-<list_name>" do
          klass.list.key.should == "#{klass.name}-list"
        end
      end

      describe "#all" do
        context "when empty" do
          it "should return []" do
            klass.list.all.should == []
          end
        end

        context "when not empty" do
          before do
            @objs = [
              {"hello" => "world"},
              {"hello2" => "world2"} ]
            klass.list.add(@objs)
          end

          after do
            klass.list.clear
          end

          it "should return objects" do
            klass.list.all.should == @objs
          end
        end
      end

      describe "#add" do
        context "with one obj" do
          before do
            @obj = {"hello" => "world"}
          end

          it "should left push serialized obj onto Redis list" do
            Redistry.client.should_receive(:lpush).with(klass.list.key,
              @obj.to_json)
            klass.list.add(@obj)
          end
        end

        context "with multiple objs" do
          before do
            @objs = [
              {"hello" => "world"},
              {"hello2" => "world2"} ]
          end

          it "should left push each serialized obj onto Redis list" do
            @objs.each do |obj|
              Redistry.client.should_receive(:lpush).with(klass.list.key,
                obj.to_json)
            end
            klass.list.add(@objs)
          end
        end
      end

      describe "#clear" do
        it "should call DEL on Redis key" do
          Redistry.client.should_receive(:del).with(klass.list.key)
          klass.list.clear
        end
      end
    end

    context "with specified class" do
      before do 
        klass.send(:has_list, :list, :class => Hash)
      end

      describe "#klass" do
        it "should use specified class" do
          klass.list.klass.should == Hash
        end
      end
    end
  end
end
