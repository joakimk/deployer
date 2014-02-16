require "spec_helper"
require "build_presenter"
require "ostruct"
require "build_mapping"

stub_class :Build, OpenStruct

describe BuildPresenter, "#list" do
  it "returns builds" do
    builds = [
      Build.new(name: "tests"),
      Build.new(name: "deploy"),
    ]

    presenter = BuildPresenter.new(builds, [])

    expect(presenter.list.map(&:name)).to eq([ "tests", "deploy" ])
  end

  it "maps build names when mappings is available" do
    builds = [
      Build.new(name: "foo_tests"),
      Build.new(name: "foo_deploy"),
    ]
    build_mappings = [ BuildMapping.new("foo_tests", "tests") ]

    presenter = BuildPresenter.new(builds, build_mappings)

    expect(presenter.list.map(&:name)).to eq([ "tests", "foo_deploy" ])
  end

  it "sorts the builds based on mappings" do
    builds = [
      Build.new(name: "foo_deploy_production"),
      Build.new(name: "foo_tests"),
      Build.new(name: "foo_deploy_staging"),
    ]
    build_mappings = [
      BuildMapping.new("foo_tests", "tests"),
      BuildMapping.new("foo_deploy_staging", "staging")
    ]

    presenter = BuildPresenter.new(builds, build_mappings)

    expect(presenter.list.map(&:name)).to eq([ "tests", "staging", "foo_deploy_production" ])
  end

  it "fills out with blank build results until they turn up" do
    builds = [
      Build.new(name: "foo_tests", status: "building")
    ]
    build_mappings = [
      BuildMapping.new("foo_tests", "tests"),
      BuildMapping.new("foo_deploy_staging", "staging")
    ]

    presenter = BuildPresenter.new(builds, build_mappings)

    expect(presenter.list.map(&:name)).to eq([ "tests", "staging" ])
    expect(presenter.list.map(&:status)).to eq([ "building", "pending" ])
  end
end