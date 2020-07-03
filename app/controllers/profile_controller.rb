class ProfileController < ApplicationController
  include Wicked::Wizard
  
  before_action :authenticate_user!
  before_action :set_user
  
  # The index is only used for redirecting in Wicked
  skip_after_action :verify_policy_scoped
  
  steps :personal_name, :formal_name, :pronunciation, :pronouns, :slug
  
  # Wicked methods needed in views
  helper_method :next_step, :previous_step

  def show
    render_wizard
  end
  
  def update
    if params[:button] == 'finish'
      @next_step = Wicked::FINISH_STEP
    end
    @user.assign_attributes(permitted_attributes @user)
    if params.dig(:user, :pronunciation, :data).present?
      @user.pronunciation.attach(data: params.dig(:user, :pronunciation, :data), filename: 'pronunciation.webm', content_type: 'audio/webm', identify: false)
    end
    render_wizard @user
  end
    
  def process_resource!(resource, options = {})
    if !resource&.valid?
      @skip_to = nil
    else
      super
    end
  end
  
  private
  
  def set_user
    @user = current_user
    authorize @user, :update?
  end
  
end
