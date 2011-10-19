require 'spec_helper' 

class SnoopDogg ; end

module Redistry 
  module List
    describe CollectionProxy do
      let(:collection_name) { 'the-dogg-pound' }

      describe 'instantiation' do
        let(:proxy) { CollectionProxy.new(SnoopDogg, collection_name) }

        context 'required parameters' do
          it 'should set the klass instance variable' do
            proxy.klass.should == SnoopDogg
          end

          it 'should set the collection_name instance variable' do
            proxy.collection_name.should == collection_name
          end

          it 'should setup the default options' do
            proxy.options.should == { :size => nil }
          end
        end

        context 'optional parameters' do
          let(:proxy) { CollectionProxy.new(SnoopDogg, collection_name, { :size => 10, :calvin => 'broadus' }) }

          it 'should merge the default options with the passed in options' do
            proxy.options.should include(:size   => 10)
            proxy.options.should include(:calvin => 'broadus')
          end 
        end

        context 'serializer' do
          describe 'given that the loaded frameworks include :activerecord' do
            before do
              Redistry.loaded_frameworks = [:activerecord]
            end

            context 'and the passed in class inherits from ActiveRecord::Base' do
              before do
                ActiveRecord       = Class.new
                ActiveRecord::Base = Class.new

                @doctor_dre = Class.new(ActiveRecord::Base)
                @proxy      = CollectionProxy.new(@doctor_dre, collection_name)
              end

              it 'should be an instance of the redistry ActiveRecord serializer' do
                @proxy.serializer.should be_instance_of(Redistry::Serializers::ActiveRecord)
              end
            end

            context 'and the passed in class does not inherit from ActiveRecord::Base' do
              it 'should be an instance of the redistry JSON serializer' do
                proxy.serializer.should be_instance_of(Redistry::Serializers::JSON)
              end
            end
          end

          context 'given that the loaded frameworks do not include :activerecord' do
            before do
              Redistry.loaded_frameworks = []
            end

            it 'should be an instance of the redistry JSON serializer' do
              proxy.serializer.should be_instance_of(Redistry::Serializers::JSON)
            end
          end
        end
      end

      describe 'instance methods' do
        let(:proxy)  { CollectionProxy.new(SnoopDogg, collection_name) }
        let(:client) { stub }

        before do
          Redistry.stub!(:client).and_return(client)
        end 

        describe '#all' do
          let(:serialized_obs) { stub(:nil? => false, :empty? => false) }
          
          before do
            client.should_receive(:lrange).with(proxy.key, 0, -1).and_return(serialized_obs)
          end

          context 'given that the serialized objects are nil' do
            it 'should return an empty array' do
              serialized_obs.should_receive(:nil?).and_return(true)

              proxy.all.should == []
            end
          end

          context 'given that the serialized objects are empty' do
            it 'should return an empty array' do
              serialized_obs.should_receive(:empty?).and_return(true)

              proxy.all.should == []
            end
          end

          context 'given that the serialized objects are not nil or empty' do
            it 'should call #deserialize on the serialized objects' do
              proxy.serializer.should_receive(:deserialize).with(SnoopDogg, serialized_obs)

              proxy.all
            end
          end
        end

        describe '#add' do
          let(:objs) { [1, 2] }

          before do
            proxy.serializer.should_receive(:serialize).with(SnoopDogg, objs).and_return(objs.flatten)

            client.stub!(:lpush).with('SnoopDogg-the-dogg-pound', 1)
            client.stub!(:lpush).with('SnoopDogg-the-dogg-pound', 2)
          end

          it 'should return itself' do
            proxy.add([1,2]).should == proxy
          end
 
          context 'given a collection proxy with no size option' do
            it 'should push the given objects to the redis list' do
              client.should_receive(:lpush).with('SnoopDogg-the-dogg-pound', 1)
              client.should_receive(:lpush).with('SnoopDogg-the-dogg-pound', 2)

              proxy.add(objs)
            end
          end

          context 'given a collection proxy with a size option' do
            let(:size) { 5 }

            before do
              proxy.stub!(:options).and_return(:size => size)
            end

            it 'should remove list elements greater than the passed in size option' do
              client.should_receive(:ltrim).with('SnoopDogg-the-dogg-pound', 0, size - 1)

              proxy.add(objs)
            end
          end
        end

        describe '#clear' do
          it 'should delete the serialized string at #key' do
            client.should_receive(:del).with(proxy.key)
          
            proxy.clear
          end

          it 'should return itself' do
            client.stub!(:del)

            proxy.clear.should == proxy
          end
        end

        describe '#key' do
          it 'should return a string built from the class and collection names' do
            proxy.key.should == "SnoopDogg-#{collection_name}"
          end
        end
      end
    end
  end
end
