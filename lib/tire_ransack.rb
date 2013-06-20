require 'tire'
require 'tire_ransack/version'
require 'tire_ransack/core_ext'
require 'tire_ransack/naming'
require 'tire_ransack/search'
require 'tire_ransack/model'

module TireRansack

  def self.val_to_array(val)
    return [] unless val
    return val if val.is_a?(Array)
    val.to_s.split(',').map(&:to_i).reject(&:zero?)
  end

end


