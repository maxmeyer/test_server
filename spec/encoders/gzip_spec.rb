# encoding: utf-8
require 'spec_helper'

describe Encoders::Gzip do
  context '#encode' do
    it 'encodes string' do
      encoder = Encoders::Gzip.new
      expect(encoder.encode('string')).to eq "x\x9C+.)\xCA\xCCK\a\x00\tB\x02\x98".force_encoding('ASCII-8Bit')
    end
  end

  context '#decode' do
    it 'decodes string' do
      encoder = Encoders::Gzip.new
      expect(encoder.decode("x\x9C+.)\xCA\xCCK\a\x00\tB\x02\x98")).to eq 'string'
    end
  end
end
