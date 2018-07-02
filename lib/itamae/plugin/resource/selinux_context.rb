
require 'itamae/plugin/resource/selinux_context/version'
require "itamae"

module Itamae
  module Plugin
    module Resource
      class SelinuxContext < Itamae::Resource::Base
        include Itamae::Plugin::Resource::SelinuxContextVersion
        define_attribute :action, default: :run
        define_attribute :file, type: String, default_name: true
        define_attribute :context, type: String, required: true
        define_attribute :debug, default: nil

        def set_current_attributes
          super
          command_result = run_command("ls -Z #{attributes.file} | grep '#{attributes.context}'", error: false)
          if attributes.debug
            Itamae.logger.info "command: ls -Z #{attributes.file} | grep '#{attributes.context}"
            Itamae.logger.info "exit code: #{command_result.exit_status}"
            Itamae.logger.info "stdout: #{command_result.stdout}"
            Itamae.logger.info "stderr: #{command_result.stderr}"
          end
          current.exist = command_result.exit_status == 0
          if current.exist
            Itamae.logger.info "Already set context of #{attributes.file}" if attributes.debug
          else
            Itamae.logger.info "Set context to #{attributes.file}"
          end
        end

        def action_run(options)
          unless current.exist
            run_command("sudo chcon #{attributes.context} #{attributes.file}")
            updated!
          end
        end
      end
    end
  end
end
