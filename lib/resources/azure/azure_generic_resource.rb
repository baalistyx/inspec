# encoding: utf-8

require 'resources/azure/azure_backend'
require 'utils/filter'

module Inspec::Resources
  class AzureGenericResource < AzureResourceBase
    name 'azure_generic_resource'

    desc '
      Inspec Resource to interrogate any Resource type in Azure
    '

    supports platform: 'azure'

    attr_accessor :filter, :total, :counts, :name, :type, :location, :probes

    def initialize(opts = {})
      warn "[DEPRECATED] use a specific azure resources instead of 'azure_generic_resource'. See https://github.com/inspec/inspec/issues/3131"

      # Call the parent class constructor
      super(opts)

      # Get the resource group
      resource_group

      # Get the resources
      resources

      # Create the tag methods
      create_tag_methods
    end

    # Define the filter table so that it can be interrogated
    @filter = FilterTable.create
    @filter.add_accessor(:count)
           .add_accessor(:entries)
           .add_accessor(:where)
           .add_accessor(:contains)
           .add(:exist?, field: 'exist?')
           .add(:type, field: 'type')
           .add(:name, field: 'name')
           .add(:location, field: 'location')
           .add(:properties, field: 'properties')

    @filter.connect(self, :probes)

    def parse_resource(resource)
      # return a hash of information
      parsed = {
        'location' => resource.location,
        'name' => resource.name,
        'type' => resource.type,
        'exist?' => true,
        'properties' => AzureResourceProbe.new(resource.properties),
      }

      parsed
    end
  end
end
