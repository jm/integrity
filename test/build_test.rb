require File.dirname(__FILE__) + '/test_helper'

describe "Build" do
  Build = Integrity::Build
  
  before(:each) do
    setup_and_reset_database!
  end
  
  specify "fixture is valid and can be saved" do
    lambda do
      Build.generate.tap do |build|
        build.should be_valid
        build.save
      end
    end.should change(Build, :count).by(1)
  end
  
  describe "Properties" do
    before(:each) do
      @build = Build.generate(:commit_identifier => "658ba96cb0235e82ee720510c049883955200fa9")
    end
    
    it "captures the build's STDOUT/STDERR" do
      @build.output.should_not be_blank
    end
    
    it "knows if it failed or not" do
      @build.successful = true
      @build.should be_successful
      @build.successful = false
      @build.should be_failed
    end
    
    it "knows it's status" do
      @build.successful = true
      @build.status.should be(:success)
      @build.successful = false
      @build.status.should be(:failed)
    end
    
    it "has a commit identifier" do
      @build.commit_identifier.should be("658ba96cb0235e82ee720510c049883955200fa9")
    end
  end
end