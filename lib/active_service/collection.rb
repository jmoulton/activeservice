require 'active_support/core_ext/module/delegation'

module ActiveService
  class Collection
    include Enumerable

    delegate :to_yaml, :all?, *Array.instance_methods(false), :to => :to_a

    # The array of actual elements returned by index actions
    attr_accessor :elements

    # ActiveService::Collection is a wrapper to handle parsing index responses that
    # do not directly map to Rails conventions. Implementation details are heavily
    # influenced by ActiveResource::Collection
    #
    # You can define a custom class that inherets from ActiveService::Collection
    # in order to to set the elements instance.
    #
    # GET /posts.json delivers following response body:
    #   {
    #     posts: [
    #       {
    #         title: "ActiveService now has associations",
    #         body: "Lorem Ipsum"
    #       }
    #       {...}
    #     ]
    #     next_page: "/posts.json?page=2"
    #   }
    #
    # A Post class can be setup to handle it with:
    #
    #   class Post < ActiveService::Base
    #     self.site = "http://example.com"
    #     self.collection_parser = PostCollection
    #   end
    #
    # And the collection parser:
    #
    #   class PostCollection < ActiveService::Collection
    #     attr_accessor :next_page
    #     def initialize(parsed = {})
    #       @elements = parsed['posts']
    #       @next_page = parsed['next_page']
    #     end
    #   end
    #
    # The result from a find method that returns multiple entries will now be a
    # PostParser instance.  ActiveService::Collection includes Enumerable and
    # instances can be iterated over just like an array.
    #    @posts = Post.find(:all) # => PostCollection:xxx
    #    @posts.next_page         # => "/posts.json?page=2"
    #    @posts.map(&:id)         # =>[1, 3, 5 ...]
    #
    # The initialize method will receive the ActiveService::Formats parsed result
    # and should set @elements.
    def initialize(elements = [])
      message = "Collection elements should be an Array."
      raise ActiveService::Errors::ParserError, message unless elements.is_a? Array
      @elements = elements
    end

    def to_a
      elements
    end

    def is_a?(klass)
      (klass == Array) || super
    end

    def collect!
      return elements unless block_given?
      set = []
      each { |o| set << yield(o) }
      @elements = set
      self
    end
    alias map! collect!
  end
end
