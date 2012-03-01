# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rcqrs"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Smith"]
  s.date = "2012-03-01"
  s.description = "A Ruby implementation of Command-Query Responsibility Segregation (CQRS) with Event Sourcing, based upon the ideas of Greg Young."
  s.email = "ben@slashdotdash.net"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/boot.rb",
    "lib/bus/command_bus.rb",
    "lib/bus/event_bus.rb",
    "lib/bus/router.rb",
    "lib/commands/active_model.rb",
    "lib/commands/handlers/base_handler.rb",
    "lib/commands/invalid_command.rb",
    "lib/domain/aggregate_root.rb",
    "lib/event_store/adapters/active_record_adapter.rb",
    "lib/event_store/adapters/data_mapper_adapter.rb",
    "lib/event_store/adapters/in_memory_adapter.rb",
    "lib/event_store/domain_event_storage.rb",
    "lib/event_store/domain_repository.rb",
    "lib/events/domain_event.rb",
    "lib/events/handlers/async_handler.rb",
    "lib/events/handlers/base_handler.rb",
    "lib/rcqrs.rb",
    "lib/rcqrs/setting.rb",
    "lib/support/guid.rb",
    "lib/support/initializer.rb",
    "lib/support/serialization.rb",
    "rcqrs.gemspec",
    "spec/bus/command_bus_spec.rb",
    "spec/bus/command_router_spec.rb",
    "spec/bus/event_bus_spec.rb",
    "spec/bus/mock_async_handler.rb",
    "spec/bus/mock_router.rb",
    "spec/commands/command_spec.rb",
    "spec/commands/create_company_command.rb",
    "spec/commands/handlers/command_handler_spec.rb",
    "spec/commands/handlers/create_company_handler.rb",
    "spec/domain/company.rb",
    "spec/domain/company_spec.rb",
    "spec/domain/expense.rb",
    "spec/domain/invoice.rb",
    "spec/event_store/active_record_adapter_spec.rb",
    "spec/event_store/domain_repository_spec.rb",
    "spec/events/company_created_event.rb",
    "spec/events/domain_event_spec.rb",
    "spec/events/handlers/company_created_handler.rb",
    "spec/events/handlers/event_handler_spec.rb",
    "spec/events/invoice_created_event.rb",
    "spec/initializer_spec.rb",
    "spec/reporting/company.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/slashdotdash/rcqrs"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.15"
  s.summary = "CQRS library in Ruby"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<uuidtools>, [">= 0"])
      s.add_runtime_dependency(%q<eventful>, ["= 1.0.0"])
      s.add_runtime_dependency(%q<jeweler>, [">= 0"])
      s.add_runtime_dependency(%q<resque>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
    else
      s.add_dependency(%q<uuidtools>, [">= 0"])
      s.add_dependency(%q<eventful>, ["= 1.0.0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<resque>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<uuidtools>, [">= 0"])
    s.add_dependency(%q<eventful>, ["= 1.0.0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<resque>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
  end
end

