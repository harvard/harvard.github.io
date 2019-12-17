require "json"
require "open-uri"

module Jekyll
  module GetFilter

    # Get API responses
    def get(rows)

      # Tuples to be returned
      tuples = {}

      # For each row in sorted order
      rows.sort_by { |row| row["repo"].downcase }.each do |row|

        # If a GitHub repo
        if row["repo"] =~ /^https?:\/\/(?:www\.)?github\.com\/([^\/]*)\/([^\/]*)\/?/

          # Remember login, name
          login, name = $1, $2

          # If we've not yet seen this login
          if not tuples.key?(login)

            # GET https://api.github.com/users/:login
            begin
              sleep(1)  # To avoid API limits
              url = "https://api.github.com/users/#{login}"
              print "Fetching #{url}... "
              response = JSON.parse(open(url).read)
              print "200 OK\n"
              tuples[login] = response, []  # Tuple for this owner and its repos
            rescue => e
              print "#{e}\n"
              next
            end
          end
          begin
            sleep(1)  # To avoid API limits
            url = "https://api.github.com/repos/#{login}/#{name}"
            print "Fetching #{url}... "
            response = JSON.parse(open(url).read)
            print "200 OK\n"
            tuples[login][1].push(response)  # Another repo for this owner
          rescue => e
            print "#{e}\n"
          end
        else
          print "Ignoring #{repo}.\n"
        end
      end
      tuples.values  # Return tuples
    end
  end
end

Liquid::Template.register_filter(Jekyll::GetFilter)
