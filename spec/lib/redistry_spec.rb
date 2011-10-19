require 'spec_helper'

describe Redistry do
  describe 'module methods' do
    specify '.client should return an instance of Redis' do
      Redistry.client.should be_an_instance_of(Redis)
    end

    describe '.setup!' do
      before do
        Redistry.loaded_frameworks = nil
      end

      context 'given that ActiveRecord is defined' do
        before do
          ActiveRecord       = Class.new
          ActiveRecord::Base = Class.new
        end

        after { Object.send(:remove_const, :ActiveRecord) }

        it 'should initialize the loaded frameworks array and add :activerecord to it' do
          expect { Redistry.setup! }.to change { Redistry.loaded_frameworks}.from(nil).to([:activerecord])
        end
      end

      context 'given that ActiveRecord is not defined' do
        it 'should initialize the loaded frameworks array' do
          expect { Redistry.setup! }.to change { Redistry.loaded_frameworks }.from(nil).to([])
        end
      end
    end
  end
end
