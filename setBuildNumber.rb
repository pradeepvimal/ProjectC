require 'tempfile'
require 'fileutils'

# USAGE:	ruby setBuildNumber.rb [plist filename] [build number]
# EXAMPLE:	ruby setBuildNumber.rb info.plist 1999

plistFile = ARGV[0]
buildNumber = ARGV[1]

puts "Setting build number to '#{buildNumber}' in the file '#{plistFile}'..."

tempFile = Tempfile.new('temp.txt')
exitCode = 1
foundLine = false
wroteLine = false

begin
  File.open(plistFile, 'r') do |file|
    
	file.each_line do |line|
	  
	  if foundLine
	    line = "<string>#{buildNumber}</string>"
		wroteLine = true
	  end
	  
	  if line.include? "<key>CFBundleVersion</key>"
	    foundLine = true
	  else
	    foundLine = false
	  end
	  
      tempFile.puts line
    end
	
  end
  
  tempFile.close
  FileUtils.mv(tempFile.path, plistFile)
ensure
  tempFile.close
  tempFile.unlink
  
  if wroteLine
    puts "Successfully set build number to '#{buildNumber}' in the file '#{plistFile}'!"
	exitCode = 0
  end
end

exit exitCode
