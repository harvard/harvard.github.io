require "json"
require "open-uri"

module Jekyll
  module GetFilter

    # Check for environment variables
    if not ENV["GITHUB_ACTOR"]
      raise "GITHUB_ACTOR not set"
    elsif not ENV["GITHUB_TOKEN"]
      raise "GITHUB_TOKEN not set"
    end

    # Tuples with owners and respositories
    @@tuples = {}

    # Get API responses
    def get(rows)

      # If memoized
      if not @@tuples.empty?
        return @@tuples.values
      end

      # For each row in sorted order
      rows.sort_by { |row| row["repo"].downcase }.each do |row|

        # If a GitHub repo
        if row["repo"] =~ /^https?:\/\/(?:www\.)?github\.com\/([^\/]*)\/([^\/]*)\/?/

          # Remember login, name
          login, name = $1, $2

          # If we've not yet seen this login
          if not @@tuples.key?(login)

            # GET https://api.github.com/users/:login
            begin
              sleep(1)  # To avoid API limits
              url = "https://api.github.com/users/#{login}"
              print "Fetching #{url}... "
              response = JSON.parse(open(url, :http_basic_authentication => [ENV["GITHUB_ACTOR"], ENV["GITHUB_TOKEN"]]).read)
              print "200 OK\n"
              @@tuples[login] = response, []  # Tuple for this owner and its repos
            rescue => e
              print "#{e}\n"
              puts open("https://api.github.com/rate_limit", :http_basic_authentication => [ENV["GITHUB_ACTOR"], ENV["GITHUB_TOKEN"]]).read
              next
            end
          end
          begin
            sleep(1)  # To avoid API limits
            url = "https://api.github.com/repos/#{login}/#{name}"
            print "Fetching #{url}... "
            response = JSON.parse(open(url, :http_basic_authentication => [ENV["GITHUB_ACTOR"], ENV["GITHUB_TOKEN"]]).read)
            print "200 OK\n"
            @@tuples[login][1].push(response)  # Another repo for this owner
          rescue => e
            print "#{e}\n"
            puts open("https://api.github.com/rate_limit", :http_basic_authentication => [ENV["GITHUB_ACTOR"], ENV["GITHUB_TOKEN"]]).read
          end
        else
          print "Ignoring #{repo}.\n"
        end
      end
      @@tuples.values  # Return tuples
    end
  end
end

Liquid::Template.register_filter(Jekyll::GetFilter)
