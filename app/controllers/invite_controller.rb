require 'digest/md5'  
class InviteController < ApplicationController
  # GET /invites
  # GET /invites.xml
  def index
  	@actived = {"invite" => "active"}
  	myuid = session[:user_id]
  	need_time = 1000#邀请码生成时间
  	@percent = 0;
  	
	if !myuid #是否登陆
			flash[:notice] = '<div class="status error">
							<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
							<p>请先登录.</p>
					</div>'
			redirect_to :controller=>"account",:action=>"login"
			return
	end
	
	@invites = Invite.find(:all,:conditions => ["uid = ? and stat = 1",myuid])#查询邀请码
	@invite_count = 1
	invite = Invite.find(:first,:order => "created_at desc",:conditions => ["uid = ? ",myuid],:limit=>1)	

	if !invite 
		@invite_f = Invite.new	
		@invite_f.code = Digest::MD5.hexdigest(myuid.to_s + Time.now.to_s+rand(1000).to_s).slice(0,10)
		@invite_f.uid  = myuid
		@invite_f.save
		return
	end	
	
	@invite_count = Invite.count(:all,:conditions => ["uid = ? and stat = 1",myuid])
	
	@percent = (Time.now.to_i - invite.created_at.to_i)*100 / need_time
	if Time.now.to_i - invite.created_at.to_i > need_time && @invite_count <20
		invite = Invite.new	
		invite.code = Digest::MD5.hexdigest(myuid.to_s + Time.now.to_s+rand(1000).to_s).slice(0,10)
		invite.uid  = myuid 
		invite.save
	end
	
	account = Account.find(myuid)
	if account.admin > 0 && @invite_count <50
		30.times do
			invite = Invite.new	
			invite.code = Digest::MD5.hexdigest(myuid.to_s + Time.now.to_s+rand(1000).to_s).slice(0,10)
			invite.uid  = myuid 
			invite.save	
		end
	end
   

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invites }
    end
  end

  def code
    code = params[:id]
  	if params[:id]
		respond_to do |format|
		format.html { redirect_to("/account/register/#{code}") }
		end	
  	end
  end

  # GET /invites/1
  # GET /invites/1.xml
  def show
    @invite = Invite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invite }
    end
  end

  # GET /invites/new
  # GET /invites/new.xml
  def new
    @invite = Invite.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @invite }
    end
  end

  # GET /invites/1/edit
  def edit
    @invite = Invite.find(params[:id])
  end

  # POST /invites
  # POST /invites.xml
  def create
    @invite = Invite.new(params[:invite])

    respond_to do |format|
      if @invite.save
        flash[:notice] = 'Invite was successfully created.'
        format.html { redirect_to(@invite) }
        format.xml  { render :xml => @invite, :status => :created, :location => @invite }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invites/1
  # PUT /invites/1.xml
  def update
    @invite = Invite.find(params[:id])

    respond_to do |format|
      if @invite.update_attributes(params[:invite])
        flash[:notice] = 'Invite was successfully updated.'
        format.html { redirect_to(@invite) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @invite.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invites/1
  # DELETE /invites/1.xml
  def destroy
    @invite = Invite.find(params[:id])
    @invite.destroy

    respond_to do |format|
      format.html { redirect_to(invites_url) }
      format.xml  { head :ok }
    end
  end
end
