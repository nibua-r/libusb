require 'rubygems'
require 'ffi'

module LIBUSB
  module Call
    extend FFI::Library
    ffi_lib 'libusb-1.0'

    ClassCode = enum :libusb_class_code, [
      :CLASS_PER_INTERFACE, 0,
      :CLASS_AUDIO, 1,
      :CLASS_COMM, 2,
      :CLASS_HID, 3,
      :CLASS_PRINTER, 7,
      :CLASS_PTP, 6,
      :CLASS_MASS_STORAGE, 8,
      :CLASS_HUB, 9,
      :CLASS_DATA, 10,
      :CLASS_WIRELESS, 0xe0,
      :CLASS_APPLICATION, 0xfe,
      :CLASS_VENDOR_SPEC, 0xff
    ]

    Error = enum :libusb_error, [
      :SUCCESS, 0,
      :ERROR_IO, -1,
      :ERROR_INVALID_PARAM, -2,
      :ERROR_ACCESS, -3,
      :ERROR_NO_DEVICE, -4,
      :ERROR_NOT_FOUND, -5,
      :ERROR_BUSY, -6,
      :ERROR_TIMEOUT, -7,
      :ERROR_OVERFLOW, -8,
      :ERROR_PIPE, -9,
      :ERROR_INTERRUPTED, -10,
      :ERROR_NO_MEM, -11,
      :ERROR_NOT_SUPPORTED, -12,
      :ERROR_OTHER, -99,
    ]

    # Transfer status codes
    TransferStatus = enum :libusb_transfer_status, [
      :TRANSFER_COMPLETED,
      :TRANSFER_ERROR,
      :TRANSFER_TIMED_OUT,
      :TRANSFER_CANCELLED,
      :TRANSFER_STALL,
      :TRANSFER_NO_DEVICE,
      :TRANSFER_OVERFLOW,
    ]

    # libusb_transfer.flags values
    TransferFlags = enum :libusb_transfer_flags, [
      :TRANSFER_SHORT_NOT_OK, 1 << 0,
      :TRANSFER_FREE_BUFFER, 1 << 1,
      :TRANSFER_FREE_TRANSFER, 1 << 2,
    ]

    TransferTypes = enum :libusb_transfer_type, [
      :TRANSFER_TYPE_CONTROL, 0,
      :TRANSFER_TYPE_ISOCHRONOUS, 1,
      :TRANSFER_TYPE_BULK, 2,
      :TRANSFER_TYPE_INTERRUPT, 3,
    ]

    EndpointDirections = enum :libusb_endpoint_direction, [
      :ENDPOINT_IN, 0x80,
      :ENDPOINT_OUT, 0x00,
    ]

    DescriptorTypes = enum :libusb_descriptor_type, [
      :DT_DEVICE, 0x01,
      :DT_CONFIG, 0x02,
      :DT_STRING, 0x03,
      :DT_INTERFACE, 0x04,
      :DT_ENDPOINT, 0x05,
      :DT_HID, 0x21,
      :DT_REPORT, 0x22,
      :DT_PHYSICAL, 0x23,
      :DT_HUB, 0x29,
    ]
    
    RequestTypes = enum :libusb_request_type, [
      :REQUEST_TYPE_STANDARD, (0x00 << 5),
      :REQUEST_TYPE_CLASS, (0x01 << 5),
      :REQUEST_TYPE_VENDOR, (0x02 << 5),
      :REQUEST_TYPE_RESERVED, (0x03 << 5),
    ]

    RequestRecipients = enum :libusb_request_recipient, [
      :RECIPIENT_DEVICE, 0x00,
      :RECIPIENT_INTERFACE, 0x01,
      :RECIPIENT_ENDPOINT, 0x02,
      :RECIPIENT_OTHER, 0x03,
    ]

    typedef :pointer, :libusb_context
    typedef :pointer, :libusb_device_handle
    
    attach_function 'libusb_init', [ :pointer ], :libusb_error
    attach_function 'libusb_exit', [ :pointer ], :void
    attach_function 'libusb_set_debug', [:pointer, :int], :void

    attach_function 'libusb_get_device_list', [:pointer, :pointer], :size_t
    attach_function 'libusb_free_device_list', [:pointer, :int], :void
    attach_function 'libusb_ref_device', [:pointer], :pointer
    attach_function 'libusb_unref_device', [:pointer], :void

    attach_function 'libusb_get_device_descriptor', [:pointer, :pointer], :libusb_error
    attach_function 'libusb_get_active_config_descriptor', [:pointer, :pointer], :libusb_error
    attach_function 'libusb_get_config_descriptor', [:pointer, :uint8, :pointer], :libusb_error
    attach_function 'libusb_get_config_descriptor_by_value', [:pointer, :uint8, :pointer], :libusb_error
    attach_function 'libusb_free_config_descriptor', [:pointer], :void
    attach_function 'libusb_get_bus_number', [:pointer], :uint8
    attach_function 'libusb_get_device_address', [:pointer], :uint8
    attach_function 'libusb_get_max_packet_size', [:pointer, :uint8], :int
    attach_function 'libusb_get_max_iso_packet_size', [:pointer, :uint8], :int

    attach_function 'libusb_open', [:pointer, :pointer], :libusb_error
    attach_function 'libusb_close', [:pointer], :void
    attach_function 'libusb_get_device', [:libusb_device_handle], :pointer

    attach_function 'libusb_set_configuration', [:libusb_device_handle, :int], :libusb_error
    attach_function 'libusb_claim_interface', [:libusb_device_handle, :int], :libusb_error
    attach_function 'libusb_release_interface', [:libusb_device_handle, :int], :libusb_error
    
    attach_function 'libusb_open_device_with_vid_pid', [:pointer, :int, :int], :pointer

    attach_function 'libusb_set_interface_alt_setting', [:libusb_device_handle, :int, :int], :libusb_error
    attach_function 'libusb_clear_halt', [:libusb_device_handle, :int], :libusb_error
    attach_function 'libusb_reset_device', [:libusb_device_handle], :libusb_error
    
    attach_function 'libusb_kernel_driver_active', [:libusb_device_handle, :int], :libusb_error
    attach_function 'libusb_detach_kernel_driver', [:libusb_device_handle, :int], :libusb_error
    attach_function 'libusb_attach_kernel_driver', [:libusb_device_handle, :int], :libusb_error
    
    attach_function 'libusb_get_string_descriptor_ascii', [:pointer, :uint8, :pointer, :int], :libusb_error

    attach_function 'libusb_alloc_transfer', [:int], :pointer
    attach_function 'libusb_submit_transfer', [:pointer], :libusb_error
    attach_function 'libusb_cancel_transfer', [:pointer], :libusb_error
    attach_function 'libusb_free_transfer', [:pointer], :void

    attach_function 'libusb_handle_events', [:libusb_context], :void

    
    callback :libusb_transfer_cb_fn, [:pointer], :void

    class IsoPacketDescriptor < FFI::Struct
      layout :length, :uint,
          :actual_length, :uint,
          :status, :libusb_transfer_status
    end

    # Setup packet for control transfers.
    class ControlSetup < FFI::Struct
      layout :bmRequestType, :uint8,
          :bRequest, :uint8,
          :wValue, :uint16,
          :wIndex, :uint16,
          :wLength, :uint16
    end

    class Transfer < FFI::ManagedStruct
      layout :dev_handle, :libusb_device_handle,
        :flags, :uint8,
        :endpoint, :uchar,
        :type, :uchar,
        :timeout, :uint,
        :status, :libusb_transfer_status,
        :length, :int,
        :actual_length, :int,
        :callback, :libusb_transfer_cb_fn,
        :user_data, :pointer,
        :buffer, :pointer,
        :num_iso_packets, :int

      def self.release(ptr)
        Call.libusb_free_transfer(ptr)
      end
    end
  end

  Call::ClassCode.to_h.each{|k,v| const_set(k,v) }
  Call::TransferTypes.to_h.each{|k,v| const_set(k,v) }
  Call::RequestTypes.to_h.each{|k,v| const_set(k,v) }
  Call::DescriptorTypes.to_h.each{|k,v| const_set(k,v) }

  
  # :stopdoc:
  # http://www.usb.org/developers/defined_class
  CLASS_CODES = [
    [0x01, nil, nil, "Audio"],
    [0x02, nil, nil, "Comm"],
    [0x03, nil, nil, "HID"],
    [0x05, nil, nil, "Physical"],
    [0x06, 0x01, 0x01, "StillImaging"],
    [0x06, nil, nil, "Image"],
    [0x07, nil, nil, "Printer"],
    [0x08, 0x01, nil, "MassStorage RBC Bluk-Only"],
    [0x08, 0x02, 0x50, "MassStorage ATAPI Bluk-Only"],
    [0x08, 0x03, 0x50, "MassStorage QIC-157 Bluk-Only"],
    [0x08, 0x04, nil, "MassStorage UFI"],
    [0x08, 0x05, 0x50, "MassStorage SFF-8070i Bluk-Only"],
    [0x08, 0x06, 0x50, "MassStorage SCSI Bluk-Only"],
    [0x08, nil, nil, "MassStorage"],
    [0x09, 0x00, 0x00, "Full speed Hub"],
    [0x09, 0x00, 0x01, "Hi-speed Hub with single TT"],
    [0x09, 0x00, 0x02, "Hi-speed Hub with multiple TTs"],
    [0x09, nil, nil, "Hub"],
    [0x0a, nil, nil, "CDC"],
    [0x0b, nil, nil, "SmartCard"],
    [0x0d, 0x00, 0x00, "ContentSecurity"],
    [0x0e, nil, nil, "Video"],
    [0xdc, 0x01, 0x01, "Diagnostic USB2"],
    [0xdc, nil, nil, "Diagnostic"],
    [0xe0, 0x01, 0x01, "Bluetooth"],
    [0xe0, 0x01, 0x02, "UWB"],
    [0xe0, 0x01, 0x03, "RemoteNDIS"],
    [0xe0, 0x02, 0x01, "Host Wire Adapter Control/Data"],
    [0xe0, 0x02, 0x02, "Device Wire Adapter Control/Data"],
    [0xe0, 0x02, 0x03, "Device Wire Adapter Isochronous"],
    [0xe0, nil, nil, "Wireless Controller"],
    [0xef, 0x01, 0x01, "Active Sync"],
    [0xef, 0x01, 0x02, "Palm Sync"],
    [0xef, 0x02, 0x01, "Interface Association Descriptor"],
    [0xef, 0x02, 0x02, "Wire Adapter Multifunction Peripheral"],
    [0xef, 0x03, 0x01, "Cable Based Association Framework"],
    [0xef, nil, nil, "Miscellaneous"],
    [0xfe, 0x01, 0x01, "Device Firmware Upgrade"],
    [0xfe, 0x02, 0x00, "IRDA Bridge"],
    [0xfe, 0x03, 0x00, "USB Test and Measurement"],
    [0xfe, 0x03, 0x01, "USB Test and Measurement (USBTMC USB488)"],
    [0xfe, nil, nil, "Application Specific"],
    [0xff, nil, nil, "Vendor specific"],
  ]
  CLASS_CODES_HASH1 = {}
  CLASS_CODES_HASH2 = {}
  CLASS_CODES_HASH3 = {}
  CLASS_CODES.each {|base_class, sub_class, protocol, desc|
    if protocol
      CLASS_CODES_HASH3[[base_class, sub_class, protocol]] = desc
    elsif sub_class
      CLASS_CODES_HASH2[[base_class, sub_class]] = desc
    else
      CLASS_CODES_HASH1[base_class] = desc
    end
  }

  def self.dev_string(base_class, sub_class, protocol)
    if desc = CLASS_CODES_HASH3[[base_class, sub_class, protocol]]
      desc
    elsif desc = CLASS_CODES_HASH2[[base_class, sub_class]]
      desc + " (%02x)" % [protocol]
    elsif desc = CLASS_CODES_HASH1[base_class]
      desc + " (%02x,%02x)" % [sub_class, protocol]
    else
      "Unkonwn(%02x,%02x,%02x)" % [base_class, sub_class, protocol]
    end
  end
  # :startdoc:
  

  class BulkTransfer
    def initialize
      @transfer = Call::Transfer.new Call.libusb_alloc_transfer(0)
      @transfer[:type] = TRANSFER_TYPE_BULK
      @transfer[:timeout] = 1000
    end

    def dev_handle=(dev)
      @transfer[:dev_handle] = @dev_handle = dev.pHandle
    end

    # Timeout in ms
    def timeout=(value)
      @transfer[:timeout] = value
    end

    def endpoint=(endpoint)
      endpoint = endpoint.bEndpointAddress if endpoint.respond_to? :bEndpointAddress
      @transfer[:endpoint] = endpoint
    end

    def buffer=(string)
      free_buffer
      @buffer = FFI::MemoryPointer.new(string.bytesize, 1, false)
      @buffer.write_string(string)
      @transfer[:buffer] = @buffer
      @transfer[:length] = @buffer.size
    end

    def buffer
      @transfer[:buffer].read_string(@transfer[:length])
    end

    def free_buffer
      if @buffer
        @buffer.free
        @buffer = nil
        @transfer[:buffer] = nil
        @transfer[:length] = 0
      end
    end

    def alloc_buffer(len)
      free_buffer
      @buffer = FFI::MemoryPointer.new(len, 1, false)
      @transfer[:buffer] = @buffer
      @transfer[:length] = @buffer.size
    end

    def actual_length
      @transfer[:actual_length]
    end

    def actual_buffer
      @transfer[:buffer].read_string(@transfer[:actual_length])
    end

    def callback=(proc)
      # Save proc to instance variable so that GC doesn't free
      # the proc object before the transfer.
      @callback_proc = proc do |pTrans|
        proc.call(self)
      end
      @transfer[:callback] = @callback_proc
    end

    def status
      @transfer[:status]
    end
    
    def submit!(&block)
      self.callback = block if block_given?
      
#       puts "submit transfer #{@transfer.inspect} buffer: #{@transfer[:buffer].inspect} length: #{@transfer[:length].inspect} status: #{@transfer[:status].inspect} callback: #{@transfer[:callback].inspect} dev_handle: #{@transfer[:dev_handle].inspect}"

      res = Call.libusb_submit_transfer( @transfer )
      raise "error #{res.inspect} in libusb_submit_transfer" if res!=:SUCCESS
    end

    def cancel!
      res = Call.libusb_cancel_transfer( @transfer )
      raise "error #{res.inspect} in libusb_cancel_transfer" if res!=:SUCCESS
    end
  end

  class DeviceDescriptor < FFI::Struct
    include Comparable

    layout :bLength, :uint8,
        :bDescriptorType, :uint8,
        :bcdUSB, :uint16,
        :bDeviceClass, :uint8,
        :bDeviceSubClass, :uint8,
        :bDeviceProtocol, :uint8,
        :bMaxPacketSize0, :uint8,
        :idVendor, :uint16,
        :idProduct, :uint16,
        :bcdDevice, :uint16,
        :iManufacturer, :uint8,
        :iProduct, :uint8,
        :iSerialNumber, :uint8,
        :bNumConfigurations, :uint8
  end

  class Configuration < FFI::ManagedStruct
    include Comparable

    layout :bLength, :uint8,
        :bDescriptorType, :uint8,
        :wTotalLength, :uint16,
        :bNumInterfaces, :uint8,
        :bConfigurationValue, :uint8,
        :iConfiguration, :uint8,
        :bmAttributes, :uint8,
        :maxPower, :uint8,
        :interface, :pointer,
        :extra, :pointer,
        :extra_length, :int

    members.each do |member|
      define_method(member) do
        self[member]
      end
    end

    def initialize(device, *args)
      @device = device
      super(*args)
    end

    def self.release(ptr)
      Call.libusb_free_config_descriptor(ptr)
    end

    attr_reader :device

    def interfaces
      ifs = []
      self[:bNumInterfaces].times do |i|
        ifs << Interface.new(self, self[:interface] + i*Interface.size)
      end
      return ifs
    end

    def inspect
      attrs = []
      attrs << self.bConfigurationValue.to_s
      bits = self.bmAttributes
      attrs << "SelfPowered" if (bits & 0b1000000) != 0
      attrs << "RemoteWakeup" if (bits & 0b100000) != 0
      desc = self.description
      attrs << desc if desc != '?'
      "\#<#{self.class} #{attrs.join(' ')}>"
    end

    # Return name of the configuration as String.
    def description
      return @description if defined? @description
      @description = device.try_string_descriptor_ascii(self.iConfiguration)
    end

    # Return all interface decriptions of the configuration as Array of InterfaceDescriptor s.
    def settings() self.interfaces.map {|d| d.settings }.flatten end
    # Return all endpoints of all interfaces of the configuration as Array of EndpointDescriptor s.
    def endpoints() self.settings.map {|d| d.endpoints }.flatten end

    def <=>(o)
      t = device<=>o.device
      t = bConfigurationValue<=>o.bConfigurationValue if t==0
      t
    end
  end

  class Interface < FFI::Struct
    include Comparable

    layout :altsetting, :pointer,
        :num_altsetting, :int

    def initialize(configuration, *args)
      @configuration = configuration
      super(*args)
    end

    attr_reader :configuration

    def settings
      ifs = []
      self[:num_altsetting].times do |i|
        ifs << Setting.new(self, self[:altsetting] + i*Setting.size)
      end
      return ifs
    end
    # The Device the Interface belongs to.
    def device() self.configuration.device end
    # Return all endpoints of all alternative settings as Array of EndpointDescriptor s.
    def endpoints() self.alt_settings.map {|d| d.endpoints }.flatten end

    def <=>(o)
      configuration<=>o.configuration
    end
  end

  class Setting < FFI::Struct
    include Comparable

    layout :bLength, :uint8,
        :bDescriptorType, :uint8,
        :bInterfaceNumber, :uint8,
        :bAlternateSetting, :uint8,
        :bNumEndpoints, :uint8,
        :bInterfaceClass, :uint8,
        :bInterfaceSubClass, :uint8,
        :bInterfaceProtocol, :uint8,
        :iInterface, :uint8,
        :endpoint, :pointer,
        :extra, :pointer,
        :extra_length, :int

    members.each do |member|
      define_method(member) do
        self[member]
      end
    end

    def initialize(interface, *args)
      @interface = interface
      super(*args)
    end

    attr_reader :interface

    def endpoints
      ifs = []
      self[:bNumEndpoints].times do |i|
        ifs << Endpoint.new(self, self[:endpoint] + i*Endpoint.size)
      end
      return ifs
    end

    def inspect
      attrs = []
      attrs << self.bAlternateSetting.to_s
      devclass = LIBUSB.dev_string(self.bInterfaceClass, self.bInterfaceSubClass, self.bInterfaceProtocol)
      attrs << devclass
      desc = self.description
      attrs << desc if desc != '?'
      "\#<#{self.class} #{attrs.join(' ')}>"
    end

    # Return name of the Interface as String.
    def description
      return @description if defined? @description
      @description = device.try_string_descriptor_ascii(self.iInterface)
    end

    # The Device the InterfaceDescriptor belongs to.
    def device() self.interface.configuration.device end
    # The ConfigDescriptor the InterfaceDescriptor belongs to.
    def configuration() self.interface.configuration end

    def <=>(o)
      t = interface<=>o.interface
      t = bInterfaceNumber<=>o.bInterfaceNumber if t==0
      t = bAlternateSetting<=>o.bAlternateSetting if t==0
      t
    end
  end

  class Endpoint < FFI::Struct
    include Comparable

    layout :bLength, :uint8,
        :bDescriptorType, :uint8,
        :bEndpointAddress, :uint8,
        :bmAttributes, :uint8,
        :wMaxPacketSize, :uint16,
        :bInterval, :uint8,
        :bRefresh, :uint8,
        :bSynchAddress, :uint8,
        :extra, :pointer,
        :extra_length, :int

    members.each do |member|
      define_method(member) do
        self[member]
      end
    end

    def initialize(setting, *args)
      @setting = setting
      super(*args)
    end

    attr_reader :setting

    def inspect
      endpoint_address = self.bEndpointAddress
      num = endpoint_address & 0b00001111
      inout = (endpoint_address & 0b10000000) == 0 ? "OUT" : "IN "
      bits = self.bmAttributes
      transfer_type = %w[Control Isochronous Bulk Interrupt][0b11 & bits]
      type = [transfer_type]
      if transfer_type == 'Isochronous'
        synchronization_type = %w[NoSynchronization Asynchronous Adaptive Synchronous][(0b1100 & bits) >> 2]
        usage_type = %w[Data Feedback ImplicitFeedback ?][(0b110000 & bits) >> 4]
        type << synchronization_type << usage_type
      end
      "\#<#{self.class} #{num} #{inout} #{type.join(" ")}>"
    end

    # The Device the EndpointDescriptor belongs to.
    def device() self.interface_descriptor.interface.configuration.device end
    # The ConfigDescriptor the EndpointDescriptor belongs to.
    def configuration() self.interface_descriptor.interface.configuration end
    # The Interface the EndpointDescriptor belongs to.
    def interface() self.interface_descriptor.interface end

    def <=>(o)
      t = interface_descriptor<=>o.interface_descriptor
      t = bEndpointAddress<=>o.bEndpointAddress if t==0
      t
    end
  end

  
  class Context
    def initialize
      m = FFI::MemoryPointer.new :pointer
      Call.libusb_init(m)
      @ctx = m.read_pointer
    end

    def exit
      Call.libusb_exit(@ctx)
    end

    def debug=(level)
      Call.libusb_set_debug(@ctx, level)
    end

    def device_list
      pppDevs = FFI::MemoryPointer.new :pointer
      size = Call.libusb_get_device_list(@ctx, pppDevs)
      ppDevs = pppDevs.read_pointer
      pDevs = []
      size.times do |devi|
        pDev = ppDevs.get_pointer(devi*FFI.type_size(:pointer))
        pDevs << Device.new(self, pDev)
      end
      Call.libusb_free_device_list(ppDevs, 1)
      pDevs
    end

    def handle_events
      Call.libusb_handle_events(@ctx)
    end

    def find(hash={})
      device_list.select do |dev|
        if ( !hash[:bDeviceClass] || dev.bDeviceClass == hash[:bDeviceClass] ) &&
           ( !hash[:bDeviceSubClass] || dev.bDeviceSubClass == hash[:bDeviceSubClass] ) &&
           ( !hash[:bDeviceProtocol] || dev.bDeviceProtocol == hash[:bDeviceProtocol] ) &&
           ( !hash[:bMaxPacketSize0] || dev.bMaxPacketSize0 == hash[:bMaxPacketSize0] ) &&
           ( !hash[:bcdUSB] || dev.bcdUSB == hash[:bcdUSB] ) &&
           ( !hash[:devVendor] || dev.devVendor == hash[:devVendor] ) &&
           ( !hash[:devProduct] || dev.devProduct == hash[:devProduct] ) &&
           ( !hash[:bcdDevice] || dev.bcdDevice == hash[:bcdDevice] )
          block_given? ? (yield(dev)!=false) : true
        end
      end
    end
    
    def find_with_interfaces(hash={}, &block)
      devs = find(hash, &block)
      devs += find(:bDeviceClass=>LIBUSB_CLASS_PER_INTERFACE) do |dev|
        if dev.settings.any?{|id|
              ( !hash[:bDeviceClass] || id.bInterfaceClass == hash[:bDeviceClass] ) &&
              ( !hash[:bDeviceSubClass] || id.bInterfaceSubClass == hash[:bDeviceSubClass] ) &&
              ( !hash[:bDeviceProtocol] || id.bInterfaceProtocol == hash[:bDeviceProtocol] ) }
          yield dev if block_given?
        else
          false
        end
      end
      return devs
    end
  end

  class Device
    include Comparable

    attr_reader :context

    def initialize context, pDev
      @context = context
      class << pDev
        def unref_device(id)
          Call.libusb_unref_device(self)
        end
      end
      ObjectSpace.define_finalizer(self, pDev.method(:unref_device))
      Call.libusb_ref_device(pDev)
      @pDev = pDev

      @pDevDesc = DeviceDescriptor.new
      res = Call.libusb_get_device_descriptor(@pDev, @pDevDesc)
      raise "error #{res} in libusb_get_device_descriptor" if res!=:SUCCESS
    end

    def open
      ppHandle = FFI::MemoryPointer.new :pointer
      res = Call.libusb_open(@pDev, ppHandle)
      raise "error #{res.inspect} in libusb_open" if res!=:SUCCESS
      handle = DevHandle.new self, ppHandle.read_pointer
      return yield handle if block_given?
      handle
    end

    def bus_number
      Call.libusb_get_bus_number(@pDev)
    end
    def device_address
      Call.libusb_get_device_address(@pDev)
    end
    def max_packet_size(endpoint)
      Call.libusb_get_max_packet_size(@pDev, endpoint)
    end
    def max_iso_packet_size(endpoint)
      Call.libusb_get_max_iso_packet_size(@pDev, endpoint)
    end

    def config_descriptor(index)
      ppConfig = FFI::MemoryPointer.new :pointer
      Call.libusb_get_config_descriptor(@pDev, index, ppConfig)
      pConfig = ppConfig.read_pointer
      config = Configuration.new(self, pConfig)
      config
    end

    # allow access to Descriptor members on Device
    DeviceDescriptor.members.each do |member|
      define_method(member) do
        @pDevDesc[member]
      end
    end

    def inspect
      attrs = []
      attrs << "#{self.bus_number}/#{self.device_address}"
      attrs << ("%04x:%04x" % [self.idVendor, self.idProduct])
      attrs << self.manufacturer
      attrs << self.product
      attrs << self.serial_number
      if self.bDeviceClass == LIBUSB::CLASS_PER_INTERFACE
        devclass = self.interface_descriptors.map {|i|
          LIBUSB.dev_string(i.bInterfaceClass, i.bInterfaceSubClass, i.bInterfaceProtocol)
        }.join(", ")
      else
        devclass = LIBUSB.dev_string(self.bDeviceClass, self.bDeviceSubClass, self.bDeviceProtocol)
      end
      attrs << "(#{devclass})"
      attrs.compact!
      "\#<#{self.class} #{attrs.join(' ')}>"
    end

    def try_string_descriptor_ascii(i)
      begin
        open{|h| h.string_descriptor_ascii(i) }
      rescue
        "?"
      end
    end

    # Return manufacturer of the device as String.
    def manufacturer
      return @manufacturer if defined? @manufacturer
      @manufacturer = try_string_descriptor_ascii(self.iManufacturer)
      @manufacturer.strip! if @manufacturer
      @manufacturer
    end

    # Return product name of the device as String.
    def product
      return @product if defined? @product
      @product = try_string_descriptor_ascii(self.iProduct)
      @product.strip! if @product
      @product
    end

    # Return serial number of the device as String.
    def serial_number
      return @serial_number if defined? @serial_number
      @serial_number = try_string_descriptor_ascii(self.iSerialNumber)
      @serial_number.strip! if @serial_number
      @serial_number
    end

    # Return configurations of the device as Array of Configuration s.
    def configurations
      configs = []
      bNumConfigurations.times do |config_index|
        begin
          configs << config_descriptor(config_index)
        rescue RuntimeError
          # On Windows some devices don't return it's configuration.
        end
      end
      configs
    end

    # Return all interfaces of the device as Array of Interface s.
    def interfaces() self.configurations.map {|d| d.interfaces }.flatten end
    # Return all interface decriptions of the device as Array of InterfaceDescriptor s.
    def settings() self.interfaces.map {|d| d.settings }.flatten end
    # Return all endpoints of all interfaces of the device as Array of EndpointDescriptor s.
    def endpoints() self.settings.map {|d| d.endpoints }.flatten end

    def <=>(o)
      t = bus_number<=>o.bus_number
      t = device_address<=>o.device_address if t==0
      t
    end
  end

  class DevHandle
    attr_reader :pHandle
    attr_reader :device
    
    def initialize device, pHandle
      @device = device
      @pHandle = pHandle
    end

    def close
      Call.libusb_close(@pHandle)
    end

    def string_descriptor_ascii(index)
      pString = FFI::MemoryPointer.new 0x100
      res = Call.libusb_get_string_descriptor_ascii(@pHandle, index, pString, pString.size)
      raise "error #{res} in libusb_get_string_descriptor_ascii" unless res.kind_of?(Fixnum) && res>=0
      pString.read_string(res)
    end

    def claim_interface(interface)
      interface = interface.bInterfaceNumber if interface.respond_to? :bInterfaceNumber
      res = Call.libusb_claim_interface(@pHandle, interface)
      raise "error #{res} in libusb_claim_interface" if res!=:SUCCESS
    end

    def release_interface(interface)
      interface = interface.bInterfaceNumber if interface.respond_to? :bInterfaceNumber
      res = Call.libusb_release_interface(@pHandle, interface)
      raise "error #{res} in libusb_release_interface" if res!=:SUCCESS
    end
    
    def set_configuration(configuration)
      configuration = configuration.bConfigurationValue if configuration.respond_to? :bConfigurationValue
      res = Call.libusb_set_configuration(@pHandle, interface)
      raise "error #{res} in libusb_set_configuration" if res!=:SUCCESS
    end
    
    def set_interface_alt_setting(interface_number_or_setting, alternate_setting=nil)
      alternate_setting ||= interface_number_or_setting.bAlternateSetting if interface_number_or_setting.respond_to? :bAlternateSetting
      interface_number_or_setting = interface_number_or_setting.bInterfaceNumber if interface_number_or_setting.respond_to? :bInterfaceNumber
      res = Call.libusb_set_interface_alt_setting(@pHandle, interface_number_or_setting, alternate_setting)
      raise "error #{res} in libusb_set_interface_alt_setting" if res!=:SUCCESS
    end

    def clear_halt(endpoint)
      endpoint = endpoint.bEndpointAddress if endpoint.respond_to? :bEndpointAddress
      res = Call.libusb_clear_halt(@pHandle, endpoint)
      raise "error #{res} in libusb_clear_halt" if res!=:SUCCESS
    end
    
    def reset_device
      res = Call.libusb_reset_device(@pHandle)
      raise "error #{res} in libusb_reset_device" if res!=:SUCCESS
    end

    def kernel_driver_active?(interface)
      interface = interface.bInterfaceNumber if interface.respond_to? :bInterfaceNumber
      res = Call.libusb_kernel_driver_active(@pHandle, interface)
      raise "error #{res} in libusb_kernel_driver_active" unless res==:SUCCESS || res==1
      return res==1
    end

    def detach_kernel_driver(interface)
      interface = interface.bInterfaceNumber if interface.respond_to? :bInterfaceNumber
      res = Call.libusb_detach_kernel_driver(@pHandle, interface)
      raise "error #{res} in libusb_detach_kernel_driver" if res!=:SUCCESS
    end

    def bulk_transfer(args={})
      timeout = args.delete(:timeout)
      endpoint = args.delete(:endpoint) || raise("no endpoint given")
      dataOut = args.delete(:dataOut)
      dataIn = args.delete(:dataIn)
      raise "invalid params #{args.inspect}" unless args.empty?

      tr = BulkTransfer.new
      tr.dev_handle = self
      tr.endpoint = endpoint
      tr.timeout = timeout if timeout
      if dataOut
        tr.buffer = dataOut
      elsif dataIn
        tr.alloc_buffer(dataIn)
      end
      
      stop = false
      tr.submit! do |tr2|
        stop = true
      end
      until stop
        device.context.handle_events
      end
      raise "error in bulk transfer #{tr.status}" unless tr.status==:TRANSFER_COMPLETED
      
      if dataOut
        tr.actual_length
      else
        tr.actual_buffer
      end
    end
  end

end
