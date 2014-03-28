# encoding: utf-8
require 'spec_helper'

describe Encoder do
  class MyEncoder < Encoder; end

  module MyModule
    class MyEncoder < Encoder; end
  end

  context '#name' do
    it 'returns name' do
      expect(MyEncoder.new.name).to eq(:my_encoder)
    end
    
    it 'returns demodularized name' do
      expect(MyModule::MyEncoder.new.name).to eq(:my_encoder)
    end
  end

  context '#name?' do
    it 'checks name' do
      expect(MyEncoder.new.name?(MyEncoder.new.name)).to be_true
    end
  end

  context '#hash' do
    it 'generates a hash for name' do
      expect(MyEncoder.new.hash.to_s.size).to eq(40)
    end
  end

  context '#eql?' do
    it 'compares instances for hash' do
      e1 = MyEncoder.new
      e2 = MyEncoder.new
      expect(e1.eql? e2).to be_true
    end
  end

  context '#==' do
    it 'understands equality' do
      e1 = MyEncoder.new
      e2 = MyEncoder.new
      expect(e1 == e2).to be_true
    end
  end


end
