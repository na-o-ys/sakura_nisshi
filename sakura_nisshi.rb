$: << File.dirname(__FILE__)
require 'sakura_nisshi/contents'
require 'sakura_nisshi/crawler/rss'
require 'sakura_nisshi/persistence'
require 'sakura_nisshi/logger'
require 'sakura_nisshi/twitter'

module SakuraNisshi
  class << self
    include Logger, Twitter, Persistence

    def root_path
      File.dirname(__FILE__)
    end

    def run
      Contents.register do |contents|
        contents.crawler = Crawler::RSS.new
      end

      new_items = Contents.select do |item|
        item.date > base_date 
      end
      new_items.sort_by! { |item| item.date }

      last_update = base_date
      new_items.each do |item|
        begin
          posttext = twitter_update(item)
        rescue
          post_failed $!
          next
        end

        post_succeeded item, posttext
        last_update = [item.date, last_update].max
      end

      set_base_date last_update
    end

  end
end

SakuraNisshi.run
