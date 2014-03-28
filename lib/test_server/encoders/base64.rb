# encoding: utf-8
module TestServer
  module Encoders
    class Base64 < Encoder
      def encode(string)
        ::Base64.encode64(string)
      end

      def decode(string)
        ::Base64.decode64(string)
      end
    end
  end
end
