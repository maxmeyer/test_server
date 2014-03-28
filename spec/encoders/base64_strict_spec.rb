# encoding: utf-8
require 'spec_helper'

describe Encoders::Base64Strict do
  context '#encode' do
    it 'encodes string' do
      encoder = Encoders::Base64Strict.new
      expect(encoder.encode('string')).to eq 'c3RyaW5n'
    end
  end

  context '#decode' do
    it 'decodes string' do
      encoder = Encoders::Base64Strict.new
      expect(encoder.decode( 'c3RyaW5n')).to eq 'string'
    end
  end
end
