require "json"
require "open-uri"

module Jekyll
  module GetFilter
    def get(repo)
      if repo =~ /^https?:\/\/(?:www\.)?github\.com\/(.*)/
        url = "https://api.github.com/repos/#{$1}"
        print "Fetching #{url}... "
        begin
          response = JSON.parse(open(url).read)
          print "200 OK\n"
          response
        rescue => e
          print "#{e}\n"
          nil
        end
      else
        print "Ignoring #{repo}.\n"
        nil
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::GetFilter)
