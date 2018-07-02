file_name = "Test_#{ENV["TRAVIS_JOB_ID"]}.txt"

file "#{ENV["HOME"]}/#{file_name}" do
  action :create
  content "test"
end

selinux_context "#{ENV["HOME"]}/#{file_name}" do
  context "unconfined_u:object_r:user_tmp_t:s0"
end
