require 'net/dns'
require 'resolv'

module Rex
module Proto
module DNS

module Packet

  #
  # Reconstructs a packet with both standard DNS libraries
  # Ensures that headers match the payload
  #
  # @param packet [String, Net::DNS::Packet] Data to be validated
  #
  # @return [Net::DNS::Packet]
  def self.validate(packet)
    Net::DNS::Packet.parse(
      Resolv::DNS::Message.decode(
        packet.respond_to?(:data) ? packet.data : packet
      ).encode
    )
  end

  #
  # Reads a packet into the Net::DNS::Packet format
  #
  # @param data [String, Net::DNS::Packet, Resolv::DNS::Message] Input data
  #
  # @return [Net::DNS::Packet]
  def self.encode_net(packet)
    return packet if packet.respond_to?(:data)
    Net::DNS::Packet.parse(
      packet.respond_to?(:decode) ? packet.encode : packet
    )
  end

  # Reads a packet into the Resolv::DNS::Message format
  #
  # @param data [String, Net::DNS::Packet, Resolv::DNS::Message] Input data
  #
  # @return [Resolv::DNS::Message]
  def self.encode_res(packet)
    return packet if packet.respond_to?(:decode)
    Resolv::DNS::Message.decode(
      packet.respond_to?(:data) ? packet.data : packet
    )
  end

  # Reads a packet into the raw String format
  #
  # @param data [String, Net::DNS::Packet, Resolv::DNS::Message] Input data
  #
  # @return [Resolv::DNS::Message]
  def self.encode_raw(packet)
    return packet unless packet.respond_to?(:decode) or packet.respond_to?(:data)
    packet.respond_to?(:data) ? packet.data : packet.encode
  end

  module Raw

    #
    # Convert data to big endian unsigned short
    #
    # @param data [Fixnum, Float, Array] Input for conversion
    #
    # @return [String] Raw output
    def self.to_dw(data)
      [data].flatten.pack('S>*')
    end

    #
    # Convert data from big endian unsigned short
    #
    # @param data [String] Input for conversion
    #
    # @return [Array] Integer array output
    def self.from_dw(data)
      data.unpack('S>*')
    end

    #
    # Convert data to big endian unsigned int
    #
    # @param data [Fixnum, Float, Array] Input for conversion
    #
    # @return [String] Raw output
    def self.to_dd(data)
      [data].flatten.pack('I>*')
    end

    #
    # Convert data from big endian unsigned int
    #
    # @param data [String] Input for conversion
    #
    # @return [Array] Integer array output
    def self.from_dd(data)
      data.unpack('I>*')
    end

    #
    # Convert data to big endian unsigned long
    #
    # @param data [Fixnum, Float, Array] Input for conversion
    #
    # @return [String] Raw output
    def self.to_dl(data)
      [data].flatten.pack('L>*')
    end

    #
    # Convert data from big endian unsigned long
    #
    # @param data [String] Input for conversion
    #
    # @return [Array] Integer array output
    def self.from_dl(data)
      data.unpack('L>*')
    end

    #
    # Returns request ID from raw packet skipping parsing
    #
    # @param data [String] Request data
    #
    # @return [Fixnum] Request ID
    def self.request_id(data)
      self.from_dw(data[0..1])[0]
    end
  end
end

end
end
end
