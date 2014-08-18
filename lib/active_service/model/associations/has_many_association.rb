module ActiveService
  module Model
    module Associations
      class HasManyAssociation < Association

        # @private
        def self.attach(klass, name, opts)
          opts = {
            :class_name     => name.to_s.classify,
            :name           => name,
            :data_key       => name,
            :default        => ActiveService::Collection.new,
            :path           => "/#{name}",
            :inverse_of => nil
          }.merge(opts)
          klass.associations[:has_many] << opts

          klass.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{name}
              puts "#{name.to_s} has_many getter called"
              cached_name = :"@association_#{name}"

              cached_data = (instance_variable_defined?(cached_name) && instance_variable_get(cached_name))
              puts "#{name.to_s} has_many getter called, cached_data found" if cached_data 
              cached_data || instance_variable_set(cached_name, ActiveService::Model::Associations::HasManyAssociation.proxy(self, #{opts.inspect}))
            end
          RUBY
        end

        # @private
        def self.parse(association, klass, data)
          data_key = association[:data_key]
          return {} unless data[data_key]

          klass = klass.nearby_class(association[:class_name])
          # { association[:name] => ActiveService::Model::Attributes.initialize_collection(klass, :data => data[data_key]) }
          { association[:name] => klass.instantiate_collection(klass, data[data_key]) }
        end

        # Initialize a new object with a foreign key to the parent
        #
        # @example
        #   class User < ActiveService::Base
        #     has_many :comments
        #   end
        #
        #   class Comment < ActiveService::Base
        #   end
        #
        #   user = User.find(1)
        #   new_comment = user.comments.build(:body => "Hello!")
        #   new_comment # => #<Comment user_id=1 body="Hello!">
        # TODO: This only merges the id of the parents, handle the case
        #       where this is more deeply nested
        def build(attributes = {})
          @klass.build(attributes.merge(:"#{@parent.singularized_resource_name}_id" => @parent.id))
        end

        # Create a new object, save it and add it to the associated collection
        #
        # @example
        #   class User < ActiveService::Base
        #     has_many :comments
        #   end
        #
        #   class Comment < ActiveService::Base
        #   end
        #
        #   user = User.find(1)
        #   user.comments.create(:body => "Hello!")
        #   user.comments # => [#<Comment id=2 user_id=1 body="Hello!">]
        def create(attributes = {})
          resource = build(attributes)

          if resource.save
            @parent.attributes[@name] ||= ActiveService::Collection.new
            @parent.attributes[@name] << resource
          end

          resource
        end

        # @private
        def fetch
          puts "fetch called from has_many_association.rb"
          super.tap do |o|
            inverse_of = @opts[:inverse_of] || @parent.singularized_resource_name
            o.each { |entry| entry.send("#{inverse_of}=", @parent) }
          end
        end

        # @private
        def assign_nested_attributes(attributes)
          data = attributes.is_a?(Hash) ? attributes.values : attributes
          # @parent.attributes[@name] = ActiveService::Model::Attributes.initialize_collection(@klass, :data => data)
          @parent.attributes[@name] = ActiveService::Model::Attributes.initialize_collection(@klass, data)
        end
      end
    end
  end
end
