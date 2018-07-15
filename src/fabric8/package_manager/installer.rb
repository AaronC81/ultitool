# frozen_string_literal: true

require 'octokit'

module Fabric8
  module PackageManager
    # Responsible for installing a new tool.
    class Installer
      # Ensures that the environment is configured properly, so that packages
      # are ready to be installed.
      def self.prepare_env
        dirs = ["#{Dir.home}/.fabric8", "#{Dir.home}/.fabric8/tools"]

        dirs.each do |dir|
          raise RuntimeError, "#{dir} is a file, but should be a directory" \
            if File.exist?(dir) && !File.directory?(dir)
              
          Dir.mkdir(dir) unless File.exist?(dir)
        end
      end

      # Creates a new installer with a given repository, and a tool name and
      # version from that repo.
      def initialize(repo, name, version)
        @repo = repo
        @name = name
        @version = version
      end

      # Runs the installer.
      def install
        # Ensure environment is ready
        Installer.prepare_env

        # Get the listing of the tool
        listing = @repo.package_contents(@name, @version)

        # Create tool directory
        @target_path = "#{Dir.home}/.fabric8/tools/#{@name}"
        Dir.mkdir(@target_path)

        def handle_item(item, rel_path)
          p item
          if item.is_a? String
            # If it's a file, download it
            contents = @repo.package_file_contents(@name, @version,
              "#{rel_path}/#{item}")

            File.write("#{@target_path}/#{rel_path}/#{item}", contents)
          else
            # If it's a directory, create it and recurse
            name, contents = item.to_a[0]
            new_path = "#{@target_path}/#{rel_path}/#{name}"
            Dir.mkdir(new_path)

            contents.each { |x| handle_item(x, new_path) }
          end
        end

        listing.each { |x| handle_item(x, '') }
      end
    end
  end
end 
    