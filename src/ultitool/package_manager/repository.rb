# frozen_string_literal: true

require 'octokit'
require 'base64'

module UltiTool
  module PackageManager
    # A GitHub repository from which tools may be retrieved using the GitHub
    # REST API v3.
    class Repository
      attr_reader :repo_id

      # Create a new repository object, given its repository name in the format
      # repo/user.
      def initialize(repo_id)
        @repo_id = repo_id
        @client = Octokit::Client.new
      end

      # Gets a list of tool names available in this repository.
      def package_names
        # Get repo directories
        @client.contents(@repo_id)
          .select { |item| item.type == 'dir' }
          .map { |item| item.name }
      end

      # Gets the list of available versions for a tool in the repository, by
      # its name.
      def package_versions(name)
        @client.contents(@repo_id, path: name)
          .select { |item| item.type == 'dir' }
          .map { |item| item.name }
      end

      # Gets a listing of all files inside a tool.
      def package_contents(name, version)
        def get_contents(path)
          @client.contents(@repo_id, path: path).map do |item|
            if item.type == 'file'
              next item.name
            elsif item.type == 'dir'
              next { item.name => get_contents("#{path}/#{item.name}") }
            else
              raise KeyError,
                "Don't understand GitHub filetype #{item.type}"
            end
          end
        end

        get_contents("#{name}/#{version}")
      end

      # Gets the contents of a file by its relative path.
      def package_file_contents(name, version, path)
        resp = @client.contents(@repo_id, path: "#{name}/#{version}/#{path}")

        raise KeyError,
          "Don't understand encoding" unless resp.encoding == 'base64'

        Base64.decode64(resp.content)
      end
    end
  end
end
