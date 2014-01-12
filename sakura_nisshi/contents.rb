module SakuraNisshi
  module Contents
    class << self
      include Enumerable
      attr_accessor :crawler

      def each &block
        crawler.each &block
      end

      def register
        yield self 
      end

    end
  end
end
