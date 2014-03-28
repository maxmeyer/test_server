# encoding: utf-8
module TestServer
  module Encoders
    class Gzip < Encoder
      def encode(string)
        Zlib::Deflate.deflate(string)
      end

      def decode(string)
        Zlib::Inflate.inflate(string)
      end
    end
  end
end
