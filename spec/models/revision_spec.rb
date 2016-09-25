require "spec_helper"

describe Revision do
  it "requires a valid revision" do
    revision = FactoryGirl.build(:revision, name: "440f78f6de0c71e073707d9435db89f8e5390a59")
    expect(revision).to be_valid

    revision = FactoryGirl.build(:revision, name: "440f78f6de0c71e073707d9435db89f8e5390a5")
    expect(revision).not_to be_valid

    revision = FactoryGirl.build(:revision, name: "440f78f6de0c71e073707d9435db89f8e5390A59")
    expect(revision).not_to be_valid

    revision = FactoryGirl.build(:revision, name: "440f78f6de0c71e073707d9435db89f8e5390a5 ")
    expect(revision).not_to be_valid
  end
end

describe Revision, "#github_url" do
  it "is a url to the revision on github" do
    project = Project.new(repository: "git@github.com:barsoom/pipeline.git")
    revision = Revision.new(name: "7220d9a3bdd24de48435406016177be7165b1cc2")
    revision.project = project
    expect(revision.github_url).to eq("https://github.com/barsoom/pipeline/commit/7220d9a3bdd24de48435406016177be7165b1cc2")
  end

  it "is nil when there are no such url" do
    revision = Revision.new
    revision.project = Project.new
    expect(revision.github_url).to be_nil
  end
end

describe Revision, "#newer_revisions" do
  it "returns any newer revisions in the same project" do
    project = FactoryGirl.create(:project)
    revision1 = FactoryGirl.create(:revision, project: project, name: "1111111111111111111111111111111111111111")
    revision2 = FactoryGirl.create(:revision, project: project, name: "2222222222222222222222222222222222222222")

    expect(revision1.newer_revisions).to eq([ revision2 ])
    expect(revision2.newer_revisions).to eq([])
  end
end
