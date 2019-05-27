require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class CustomAction < RailsAdmin::Config::Actions::Base
        register_instance_option :visible? do
          bindings[:object].class == Question
        end

        register_instance_option :link_icon do
          'icon-eye-open'
        end

        register_instance_option :pjax? do
          true
        end
      end

      class NewQuestion < CustomAction
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :collection do
          true
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :controller do
          Proc.new do
            @question = Question.new
            if request.get?
              respond_to do |format|
                format.html {render @action.template_name}
              end
            elsif request.post?
              question_params = params.require(:question).permit :content,
                :choice, answer_attributes: [:id, :content, :status, :_destroy]
              @question = Question.new question_params
              unless @question.save!
                flash[:danger] = "Failed, try again!"
              end
              redirect_to index_path(@model_name)
            end
          end
        end
      end

    end
  end
end
