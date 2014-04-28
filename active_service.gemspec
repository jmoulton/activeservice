# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: active_service 0.5.1 ruby lib

Gem::Specification.new do |s|
  s.name = "active_service"
  s.version = "0.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["zwelchcb"]
  s.date = "2014-04-28"
  s.description = "It facilitates the creation and use of business objects through a uniform interface similar to ActiveRecord. With ActiveRecord, objects are mapped to a database via SQL SELECT, INSERT, UPDATE, and DELETE statements. With ActiveService, objects are mapped to a resource via HTTP GET, POST, PUT and DELETE requests."
  s.email = "Zachary.Welch@careerbuilder.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "LICENSE.txt",
    "README.md",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "active_service.gemspec",
    "lib/active_service.rb",
    "lib/active_service/aggregations.rb",
    "lib/active_service/associations.rb",
    "lib/active_service/associations/builder/association.rb",
    "lib/active_service/associations/builder/belongs_to.rb",
    "lib/active_service/associations/builder/has_many.rb",
    "lib/active_service/associations/builder/has_one.rb",
    "lib/active_service/base.rb",
    "lib/active_service/collection.rb",
    "lib/active_service/config.rb",
    "lib/active_service/crud.rb",
    "lib/active_service/field_map.rb",
    "lib/active_service/persistence.rb",
    "lib/active_service/reflection.rb",
    "lib/active_service/relation.rb",
    "lib/active_service/request.rb",
    "lib/ext/active_attr.rb",
    "spec/active_service/user_spec.rb",
    "spec/active_service_spec.rb",
    "spec/dummy/address.rb",
    "spec/dummy/invoice.rb",
    "spec/dummy/micropost.rb",
    "spec/dummy/person_address.rb",
    "spec/dummy/user.rb",
    "spec/spec_helper.rb",
    "spec/support/active_model_spec.rb"
  ]
  s.homepage = "http://github.com/zwelchcb/active_service"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.9"
  s.summary = "ActiveService is an object-relational mapper for web services."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<active_attr>, [">= 0"])
      s.add_runtime_dependency(%q<typhoeus>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["= 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.8.7"])
      s.add_runtime_dependency(%q<active_attr>, [">= 0"])
      s.add_runtime_dependency(%q<typhoeus>, [">= 0"])
    else
      s.add_dependency(%q<active_attr>, [">= 0"])
      s.add_dependency(%q<typhoeus>, [">= 0"])
      s.add_dependency(%q<rspec>, ["= 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.8.7"])
      s.add_dependency(%q<active_attr>, [">= 0"])
      s.add_dependency(%q<typhoeus>, [">= 0"])
    end
  else
    s.add_dependency(%q<active_attr>, [">= 0"])
    s.add_dependency(%q<typhoeus>, [">= 0"])
    s.add_dependency(%q<rspec>, ["= 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.8.7"])
    s.add_dependency(%q<active_attr>, [">= 0"])
    s.add_dependency(%q<typhoeus>, [">= 0"])
  end
end

