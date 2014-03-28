# encoding: utf-8
require 'spec_helper'

describe WebHelper do
  before :each do
    @test_object = Class.new do
      attr_accessor :params

      include WebHelper
    end.new
  end

  context '#generate_string' do
    it 'generates a string of n lines' do
      expect(@test_object.generate_string(2)).to eq "Plain Data\nPlain Data\n"
    end
  end

  context '#generate_random_string' do
    it 'generates a random string of length n' do
      expect(@test_object.generate_random_string(20).size).to eq 20
    end
  end

  context '#generate_eicar' do
    it 'generates eicar test string' do
      result = [ 'X', '5', 'O', '!', 'P', '%', '@', 'A', 'P', '[', '4', "\\", 'P',
                 'Z', 'X', '5', '4', '(', 'P', '^', ')', '7', 'C', 'C', ')', '7',
                 '}', '$', 'E', 'I', 'C', 'A', 'R', '-', 'S', 'T', 'A', 'N', 'D',
                 'A', 'R', 'D', '-', 'A', 'N', 'T', 'I', 'V', 'I', 'R', 'U', 'S',
                 '-', 'T', 'E', 'S', 'T', '-', 'F', 'I', 'L', 'E', '!', '$', 'H',
                 '+', 'H', '*' ]

      expect(@test_object.generate_eicar).to eq(result)
    end
  end

  context '#encoding' do
    it 'supports base64 encoding' do
      @test_object.params = {
        'base64' => nil,
      }

      result = @test_object.encode do
        'string'
      end

      expect(result).to eq "c3RyaW5n\n"
    end

    it 'supports strict base64 encoding' do
      @test_object.params = {
        'base64_strict' => nil,
      }

      result = @test_object.encode do
        'string'
      end

      expect(result).to eq "c3RyaW5n"
    end

    it 'supports gzip encoding' do
      @test_object.params = {
        'gzip' => nil,
      }

      result = @test_object.encode do
        'string'
      end

      expect(result).to eq "x\x9C+.)\xCA\xCCK\a\x00\tB\x02\x98".force_encoding('ASCII-8Bit')
    end

    it 'can combine multiple encodings, based on occurrence (gzip, base64)' do
      @test_object.params = {
        'gzip' => nil,
        'base64' => nil,
      }

      result = @test_object.encode do
        'string'
      end

      expect(result).to eq "eJwrLinKzEsHAAlCApg=\n"
    end

    it 'can combine multiple encodings, based on occurrence (gzip, base64)' do
      @test_object.params = {
        'base64' => nil,
        'gzip' => nil,
      }

      expect {
        result = @test_object.encode do
          'string'
        end
      }.not_to raise_error
    end

    it 'runs null encoders if no encoder is given' do
      @test_object.params = {
      }

      result = @test_object.encode do
        'string'
      end

      expect(result).to eq 'string'
    end

    it 'runs null encoders if unknown encoder is given' do
      @test_object.params = {
        'unknown' => nil,
      }

      result = @test_object.encode do
        'string'
      end

      expect(result).to eq 'string'
    end
  end

end
