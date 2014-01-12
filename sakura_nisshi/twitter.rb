require 'twitter'

module SakuraNisshi
  module Twitter

    def twitter_update(item)
      posttext = format_for_post(item)
      twitter.update(posttext)
      posttext
    end

    def config
      return @config if @config
      config_file = root_path + "/config.yml"
      @config = open(config_file, "r") { |f| YAML::load(f) }
    end

    def twitter
      @twitter ||= ::Twitter::REST::Client.new do |_config|
        _config.consumer_key        = config["consumer_key"]
        _config.consumer_secret     = config["consumer_secret"]
        _config.access_token        = config["access_token"]
        _config.access_token_secret = config["access_token_secret"]
      end
    end

    def format_for_post(item)
      "#{item.theme[0, 20]} 『#{item.title[0, 90]}』 #{item.link}"
    end

  end
end
