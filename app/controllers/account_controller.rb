require 'digest/md5'  
class AccountController < ApplicationController
  # GET /accounts
  # GET /accounts.xml
	def index
		unless Account.find(:first,:conditions => ["id=? ",session[:user_id]])	
			flash[:notice] = '<p class="msg-info">请先登录!</p>'
			redirect_to :controller=>"message"
		end
	end
  
	def login
		url=params[:id]
		@actived = {"login" => "active"}
		if request.post?
				account = Account.authenticate(params[:username],params[:password])
				if account				
					session[:user_id] = account.id
					session[:user_name] = account.username
					
				if url
					redirect_to(url)
					return
				end

					flash[:notice] = '<div class="status success">
							<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
							<p>欢迎回来,'+account.username+'</p>
					</div>'
									
					redirect_to(:controller =>"content",:action=>"index")
					
				else
					
					flash.now[:notice] = '<div class="status error">
							<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
							<p>用户名或密码错误.</p>
					</div>'
				end
						
		end
	end
	
	def register
		isopen=1;
		@actived = {"register" => "active"}
		@code = params[:code] ? params[:code] : params[:id]
		invite = Invite.find(:first,:order => "created_at desc",:conditions => ["code = ? and stat = 1",@code],:limit=>1)
		
		if invite == nil && !isopen
				flash[:notice] = '<div class="status error">
							<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
							<p>邀请码无效或已被使用.</p>
					</div>'
				redirect_to(:controller =>"message")			
				return
		end
		
		if request.post?			
			
				@account = Account.new(params[:account])
				if params[:account][:username]=='' || params[:account][:password]==''
					flash.now[:notice] = '<div class="status error">
							<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
							<p>用户名和密码都不能为空.</p>
					</div>'
					return
				end
				
				if Account.find_by_username(params[:account][:username])
					flash.now[:notice] = '<div class="status error">
							<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
							<p>用户名已经被注册了，换一个吧.</p>
					</div>'
					return
				end
				@account.md5 					
				if @account.save					
					session[:user_id] = @account.id
					session[:user_name] = @account.username
					if !isopen
					invite.used_by = @account.username
					invite.stat = 0
					invite.save
					end
					flash[:notice] = '<div class="status success">
							<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
							<p>注册成功了</p>
					</div>'				
					redirect_to(:controller =>"content",:action=>"index")
				end
						
		else #无请求
			@account = Account.new
			respond_to do |format|
			format.html # register.html.erb
			format.xml  { render :xml => @account }
			end
		end
	end

  	def setpassword
  		@actived = {"account" => "active"}
  		if !session[:user_id]
			flash[:notice] = '<div class="status error">
							<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
							<p>请先登录.</p>
					</div>'
			redirect_to :controller=>"account",:action=>"login"
			return
		end
				
  		if request.post?	
  			old=params[:oldpassword]
  			pass1=params[:password]
  			pass2=params[:password2]
  			if old=='' || pass1=='' || pass2==''
					flash.now[:notice] = '<div class="status error">
							<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
							<p>所有选项不能为空哦.</p>
					</div>'
					return
			end
			
			if pass1 != pass2  
					flash.now[:notice] = '<div class="status error">
							<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
							<p>两次输入的新密码不一样.</p>
					</div>'
					return
			end
  			
			account = Account.find(session[:user_id])
			
			if account.password != Digest::MD5.hexdigest(old)  
					flash.now[:notice] = '<div class="status error">
							<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
							<p>原密码有误.</p>
					</div>'
					return
			end
			
			account.password = pass1
			account.md5 
			account.save
			
			session[:user_id] = nil
			session[:user_name] = nil
			flash[:notice] = '<div class="status success">
								<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
								<p>密码修改成功.请重新登录</p>
						</div>'
			redirect_to :controller=>"account",:action=>"login"
		end
	end
	
  	def logout
		
		session[:user_id] = nil
		session[:user_name] = nil
		flash[:notice] = '<div class="status success">
							<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
							<p>你已经成功登出.</p>
					</div>'
		redirect_to(:controller =>"content",:action=>"index")
	end

  protected
	def authorize
	end
end
