# encoding: utf-8
require 'spec_helper'

describe Encoders::Null do
  context '#encode' do
    it 'encodes string' do
      encoder = Encoders::Null.new
      expect(encoder.encode('string')).to eq 'string'
    end
  end

  context '#decode' do
    it 'decodes string' do
      encoder = Encoders::Null.new
      expect(encoder.decode( 'string')).to eq 'string'
    end
  end
end
