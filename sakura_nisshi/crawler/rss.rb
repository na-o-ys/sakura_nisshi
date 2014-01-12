require 'forwardable'
require 'nokogiri'
require 'rss'

module SakuraNisshi
  module Crawler
    class RSS
      extend Forwardable
      include Enumerable
      def_delegators :items, :each

      URL = "http://feedblog.ameba.jp/rss/ameblo/sakuragakuin/rss20.xml"

      def initialize(url = URL)
        @url = url
      end

      def rss
        @rss ||= ::RSS::Parser.parse(@url)
      end

      def items
        return @items if @items
        @items = rss.items.reject {|item| item.title.index("PR:")}

        @items.each do |item|
          def item.theme
            doc = ::Nokogiri::HTML(open(self.link))
            theme = doc.xpath("
    //div[@id='frame']/div[@id='subFrame']/div[@id='wrap']
    /div[@id='firstContentsArea']/div[@id='subFirstContentsArea']
    /div[@id='main']/div[@id='sub_main']
    /div[@class='entry new' or @class='entry']/span[@class='theme']/a").text
          end
        end
      end

    end
  end
end
