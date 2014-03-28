# encoding: utf-8
require 'spec_helper'

describe Encoders::Base64 do
  context '#encode' do
    it 'encodes string' do
      encoder = Encoders::Base64.new
      expect(encoder.encode('string')).to eq "c3RyaW5n\n"
    end
  end

  context '#decode' do
    it 'decodes string' do
      encoder = Encoders::Base64.new
      expect(encoder.decode( "c3RyaW5n\n")).to eq 'string'
    end
  end
end
