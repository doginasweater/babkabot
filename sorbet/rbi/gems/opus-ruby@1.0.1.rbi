# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `opus-ruby` gem.
# Please instead update this file by running `bin/tapioca gem opus-ruby`.

module Opus
  extend ::FFI::Library
end

class Opus::Decoder
  # @return [Decoder] a new instance of Decoder
  #
  # source://opus-ruby//lib/opus-ruby/decoder.rb#33
  def initialize(sample_rate, frame_size, channels); end

  # Returns the value of attribute channels.
  #
  # source://opus-ruby//lib/opus-ruby/decoder.rb#31
  def channels; end

  # source://opus-ruby//lib/opus-ruby/decoder.rb#49
  def decode(data); end

  # source://opus-ruby//lib/opus-ruby/decoder.rb#41
  def destroy; end

  # Returns the value of attribute frame_size.
  #
  # source://opus-ruby//lib/opus-ruby/decoder.rb#31
  def frame_size; end

  # source://opus-ruby//lib/opus-ruby/decoder.rb#45
  def reset; end

  # Returns the value of attribute sample_rate.
  #
  # source://opus-ruby//lib/opus-ruby/decoder.rb#31
  def sample_rate; end
end

class Opus::Encoder
  # @return [Encoder] a new instance of Encoder
  #
  # source://opus-ruby//lib/opus-ruby/encoder.rb#6
  def initialize(sample_rate, frame_size, channels); end

  # Returns the value of attribute bitrate.
  #
  # source://opus-ruby//lib/opus-ruby/encoder.rb#3
  def bitrate; end

  # source://opus-ruby//lib/opus-ruby/encoder.rb#27
  def bitrate=(value); end

  # Returns the value of attribute channels.
  #
  # source://opus-ruby//lib/opus-ruby/encoder.rb#3
  def channels; end

  # source://opus-ruby//lib/opus-ruby/encoder.rb#14
  def destroy; end

  # source://opus-ruby//lib/opus-ruby/encoder.rb#32
  def encode(data, size); end

  # Returns the value of attribute frame_size.
  #
  # source://opus-ruby//lib/opus-ruby/encoder.rb#3
  def frame_size; end

  # source://opus-ruby//lib/opus-ruby/encoder.rb#18
  def reset; end

  # Returns the value of attribute sample_rate.
  #
  # source://opus-ruby//lib/opus-ruby/encoder.rb#3
  def sample_rate; end

  # Returns the value of attribute vbr_rate.
  #
  # source://opus-ruby//lib/opus-ruby/encoder.rb#3
  def vbr_rate; end

  # source://opus-ruby//lib/opus-ruby/encoder.rb#22
  def vbr_rate=(value); end
end

# source://opus-ruby//lib/opus-ruby/version.rb#2
Opus::VERSION = T.let(T.unsafe(nil), String)
