# frozen_string_literal: true

require 'bundler/gem_helper'

task :add, [:name] do |_t, args|
  p "Detected gem name: #{args.name}"
  p `bundle add #{args.name}`
  p `bundle install`
  p `bundle exec tapioca gems`
end
