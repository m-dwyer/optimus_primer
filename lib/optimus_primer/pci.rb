module OptimusPrimer
  class PciError < StandardError; end

  class Pci
    DISPLAY_DEVICE_CLASS = '03'.freeze
    INTEL_VENDOR_BUS_ID = '8086'.freeze
    NVIDIA_VENDOR_BUS_ID = '10de'.freeze

    def bus_id
      display_controllers
    end

    def display_controllers
      grouped_devices = group_by(all_devices, :pci_class_id, :vendor_id)
      display_controllers = grouped_devices.select { |d| d.start_with? DISPLAY_DEVICE_CLASS }.values
      intel_controllers = display_controllers.select { |d| d[INTEL_VENDOR_BUS_ID] }
      nvidia_controllers = display_controllers.select { |d| d[NVIDIA_VENDOR_BUS_ID] }

      [intel_controllers, nvidia_controllers]
    end

    private

    def group_by(obj, *keys)
      groups = obj.group_by { |h| h[keys.first] }

      return groups if keys.count == 1
      return groups.transform_values { |v|  group_by(v, *keys.drop(1)) }
    end

    def all_devices
      devices = []
      `lspci -Dn`.split("\n").each_with_object(devices) do |line, accum|
        pci_line = line.split("\s")
        pci_domain_bdf = pci_line[0]
        pci_class_id = pci_line[1].match(/^([a-f\d]+)\:$/)[1]
        vendor_device = pci_line[2].split(':')
        vendor_id = vendor_device[0]
        device_id = vendor_device[1]

        accum << {
          pci_domain_bdf: pci_domain_bdf,
          pci_class_id: pci_class_id,
          vendor_id: vendor_id,
          device_id: device_id
        }
      end

      devices
    end

    def write_path(path, value)
      File.write(path, value)
    end

    def read_path(path, value)
      File.read(path, value)
    end
  end
end