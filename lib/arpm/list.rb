module ARPM
  class List

    def self.register(package, version)
      # Make sure the list exists
      FileUtils.touch(path) unless File.exists?(path)

      packages = JSON.parse(File.read(path)) rescue []

      # Is any version of this pacakge installed?
      if ARPM::List.includes?(package.name)

        # Is this version already installed?
        unless ARPM::List.includes?(package.name, version)

          # No it isn't, so add this version to the list
          packages.select { |p| p.keys[0] == package.name }.first[package.name] << version

        end

      else

        # It isn't so add the whole package
        packages << {package.name => [version]}
      end

      f = File.open(path, 'w')
      f.write(JSON.generate(packages, :quirks_mode => true))
      f.close

    end

    def self.includes?(package_name, version = nil)

      # Get all the packages
      packages = JSON.parse(File.read(path)) rescue []

      # Search for the specified package
      list_package = packages.select { |p| p.keys[0] == package_name }

      # Was the version specified?
      if version

        # Yes, so only return yes if the specified version is installed
        return list_package.first[package_name].include?(version)

      else

        # No, so return yes if any versions of the package are installed
        return list_package.first
      end
    end

    private

    def self.path
      ARPM::Config.base_directory + "/arpm.txt"
    end

  end
end