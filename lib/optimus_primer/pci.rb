module OptimusPrimer
  class PciError < StandardError; end

  class Pci
    DISPLAY_DEVICE_CLASS = '03'.freeze
    INTEL_VENDOR_BUS_ID = '8086'.freeze
    NVIDIA_VENDOR_BUS_ID = '10de'.freeze
    POWER_PATH = 'power/control'.freeze

    def bus_id
      display_controllers
    end

    def display_controllers
      grouped_devices = group_by(all_devices, :pci_class_id, :vendor_id)
      intel_controllers = grouped_devices.dig(DISPLAY_DEVICE_CLASS, INTEL_VENDOR_BUS_ID)
      nvidia_controllers = grouped_devices.dig(DISPLAY_DEVICE_CLASS, NVIDIA_VENDOR_BUS_ID)

      [intel_controllers, nvidia_controllers]
    end

    def write_pci_path(device, path, value)
      File.write(pci_path(device, path), value)
    end

    def read_pci_path(device, path, value)
      File.read(pci_path(device, path), value)
    end

    private

    def pci_path(device, path)
      "/sys/bus/pci/devices/%{device}/%{path}" % { device: device, path: path }
    end

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
        pci_class_id = pci_line[1].match(/^([a-f\d]{2})[a-f\d]{2}\:$/)[1]
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
  end
end