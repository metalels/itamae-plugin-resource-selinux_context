require "spec_helper"
require "open3"

RSpec.describe Itamae::Plugin::Resource::SelinuxContext do
  it "has a version number" do
    expect(Itamae::Plugin::Resource::SelinuxContext::VERSION).not_to be nil
  end

  it "Selinux-context is set in the test file" do
    file_name = "Test_#{ENV["TRAVIS_JOB_ID"]}.txt"
    _, _, status_code = Open3.capture3 %q(ls -Z #{ENV["HOME"]}/#{file_name} | grep -q unconfined_u:object_r:user_tmp_t:s0)
    expect(status_code.success?).to eq(true)
  end
end
