#!/usr/bin/env ruby

require 'rugged'
require 'colorize'

vers_num = RUBY_VERSION[0].to_i
dir_path = ''

if vers_num >= 2
	dir_path = __dir__
else
	dir_path = File.expand_path(File.dirname(__FILE__))
end

fpath_tokens = dir_path.split("/")
fpath_tokens.slice!(-2, 2) #remove the last 2 folders of path (.git and hooks)
repo_path = fpath_tokens.join("/")

searched_path = "README.md"

crt_repo = Rugged::Repository.new(repo_path)
diffs = crt_repo.index.diff(crt_repo.head.target) 


diffs.each_delta do |del| 

	if del.new_file[:path] == searched_path
		puts "README was changed, good...".colorize(:green)
		exit(0)
	end
end

print "Warning: ".colorize(:yellow)
puts "you forgot to change README".colorize(:color => :yellow, :mode => :bold)

print "It's recommended to reset this commit with "
puts "git reset HEAD~1".colorize(:mode => :bold)

