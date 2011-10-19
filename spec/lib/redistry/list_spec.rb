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

describe Redistry::List do
  context '#has_list' do
    context "with class without id" do
      let(:klass) { StubNoId }

      it "should raise error" do
        lambda { klass.has_list(:items, :class => StubNoId) }.should raise_error(RuntimeError)
      end
    end

    context "with valid class" do
      let(:klass) { StubWithId }
      let(:instance) { klass.new(1) }

      before do
        klass.send(:has_list, :items, :class => StubWithId)
      end

      it "should have key with id" do
        instance.items.key.should == "#{klass.name}-items-1"
      end
    end
  end

  context '#list' do
    let(:klass) { StubNoId }

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
end
