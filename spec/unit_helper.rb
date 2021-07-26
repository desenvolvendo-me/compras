require 'rubygems'
require 'bundler/setup'
require 'simplecov'
SimpleCov.start if ENV["SIMPLECOV"]

$:.unshift File.expand_path('../../', __FILE__)
