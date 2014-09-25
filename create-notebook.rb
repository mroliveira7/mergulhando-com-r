#!/usr/bin/env ruby

require 'fileutils'

def create_notebook(path)
  dir = File.dirname(path)
  filename = File.basename(path)
  filename_no_ext = File.basename(filename, ".*")

  oldpwd = FileUtils.pwd
  FileUtils.chdir(dir)

  system %Q[Rscript -e "library(knitr); library(markdown); knitr::spin('#{filename}'); markdownToHTML('#{filename_no_ext}.md', '#{filename_no_ext}.html')"]

  FileUtils.chdir(oldpwd)
end

if __FILE__ == $0

  if ARGV.size == 0
    puts
    puts "Creates a report from a R script using knitr::spin."
    puts "Usage: #{File.basename(__FILE__)} R-file"
    puts
    exit 1
  end

  ARGV.each do |path|
    create_notebook(path)
  end

end
