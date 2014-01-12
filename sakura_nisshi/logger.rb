module SakuraNisshi
  module Logger

    def post_succeeded(item, posted_text)
      hours, mins, sec = calc_delay_from_now(item.date)    
      logger.info( 
        "Post Succeeded: " + 
        posted_text +
        "#{hours}h#{mins}m#{sec}s\' delay (#{item.date.strftime("%m/%d %H:%M:%S")})"
      )
    end

    def post_failed(arg)
      logger.error("Error while tweeting: #{arg}")
    end   
    
    def logger
      @logger ||= ::Logger.new(
        root_path + "/log/sakura.log", "weekly"
      ) 
    end

    def calc_delay_from_now(date)
      hours, rem = (Time.now - date).divmod(60*60)
      mins, sec = rem.divmod(60)
      return hours, mins, sec.round
    end

  end
end
