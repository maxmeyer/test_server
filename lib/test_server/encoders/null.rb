# encoding: utf-8
module TestServer
  module Encoders
    class Null < Encoder
      def encode(string)
        string
      end

      def decode(string)
        string
      end
    end
  end
end
