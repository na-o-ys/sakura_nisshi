require 'logger'
require 'yaml'
require 'twitter'
require 'time'

module SakuraNisshi
  module Persistence

    def base_date
      return @base_date if @base_date

      if File.exist?(base_date_file)
        @base_date = Time.parse(open(base_date_file, "r").read)
      else
        @base_date = Time.now - 7*24*60*60
      end
      @base_date
    end

    def set_base_date(time)
      open(base_date_file, "w") do |f|
        f.write(time.to_s)
      end
    end

    def base_date_file
      root_path + "/.base_date"
    end

  end
end
