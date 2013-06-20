require 'tire'
require 'tire_ransack/version'
require 'tire_ransack/core_ext'
require 'tire_ransack/predicate'
require 'tire_ransack/naming'
require 'tire_ransack/search'
require 'tire_ransack/model'

module TireRansack
  mattr_accessor :predicates
  self.predicates = []

  BASE_PREDICATES = [
      ['eq', {query: proc { |attr, v| {term: {attr => v}} }}],
      ['in', {query: proc { |attr, v| {terms: {attr => TireRansack.val_to_array(v)}} }}],
      ['in_all', {query: proc { |attr, v| {terms: {attr => TireRansack.val_to_array(v), execution: 'and'}} }}],
      ['gt', {query: proc { |attr, v| {range: {attr => {gt: v}}} }}],
      ['lt', {query: proc { |attr, v| {range: {attr => {lt: v}}} }}],
      ['gteq', {query: proc { |attr, v| {range: {attr => {gte: v}}} }}],
      ['lteq', {query: proc { |attr, v| {range: {attr => {lte: v}}} }}]
  ]

  class << self
    def setup
      yield self
    end

    def add_predicate(*args)
      self.predicates << Predicate.new(*args)
    end

    def val_to_array(val)
      return [] unless val
      return val if val.is_a?(Array)
      val.to_s.split(',').map(&:to_i).reject(&:zero?)
    end
  end
end

TireRansack.setup do |config|
  TireRansack::BASE_PREDICATES.each do |args|
    config.add_predicate *args
  end
end

