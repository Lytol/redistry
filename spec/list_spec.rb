require 'spec_helper'

class Stubba
  include Redistry::List
end

describe "#list" do
  let(:klass) { Stubba }

  context "without specified class" do
    before do
      klass.send(:list, :items)
    end

    describe "#items" do

      describe "#klass" do
        it "should be parent class" do
          klass.items.klass.should == klass
        end
      end

      describe "#key" do
        it "should be <class>-<items_name>" do
          klass.items.key.should == "#{klass.name}-items"
        end
      end

      describe "#all" do
        context "when empty" do
          it "should return []" do
            klass.items.all.should == []
          end
        end

        context "when not empty" do
          before do
            @objs = [
              {"hello" => "world"},
              {"hello2" => "world2"} ]
            klass.items.add(@objs)
          end

          after do
            klass.items.clear
          end

          it "should return objects" do
            klass.items.all.should == @objs
          end
        end
      end

      describe "#add" do
        context "with one obj" do
          before do
            @obj = {"hello" => "world"}
          end

          it "should left push serialized obj onto Redis items" do
            Redistry.client.should_receive(:lpush).with(klass.items.key,
              @obj.to_json)
            klass.items.add(@obj)
          end
        end

        context "with multiple objs" do
          before do
            @objs = [
              {"hello" => "world"},
              {"hello2" => "world2"} ]
          end

          it "should left push each serialized obj onto Redis items" do
            @objs.each do |obj|
              Redistry.client.should_receive(:lpush).with(klass.items.key,
                obj.to_json)
            end
            klass.items.add(@objs)
          end
        end
      end

      describe "#clear" do
        it "should call DEL on Redis key" do
          Redistry.client.should_receive(:del).with(klass.items.key)
          klass.items.clear
        end
      end
    end

    context "with specified class" do
      before do 
        klass.send(:list, :items, :class => Hash)
      end

      describe "#klass" do
        it "should use specified class" do
          klass.items.klass.should == Hash
        end
      end
    end
  end

end
