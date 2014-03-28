module TestServer
  module SpecHelper
    module Html
      def pretty_print_page(page)
        xsl_path = File.expand_path('../pretty_print.xsl', __FILE__)

        xsl = Nokogiri::XSLT(File.read(xsl_path))
        html = Nokogiri(page.source)

        xsl.apply_to(html).to_s
      end
    end
  end
end

# encoding: utf-8
RSpec.configure do |c|
  c.include TestServer::SpecHelper::Html
  c.before(:each) { cleanup_working_directory }
end
