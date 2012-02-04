class IndexController < ApplicationController
  # GET /accounts
  # GET /accounts.xml
  def index
	@actived = {"home" => "active"}
    respond_to do |format|
      format.html # index.html.erb
    end
  end

end
