# = Config
# 
# Config has options for global settings. These options are normally defined in 
# a Rails initializer or environment file. 
module ActiveService  
  class Config
    class << self      
      attr_accessor :hydra, :base_uri, :headers
      attr_writer   :default_collection_parser
      
      def default_collection_parser
        @default_collection_parser ||= ActiveService::Collection
      end
    end
  end
end
