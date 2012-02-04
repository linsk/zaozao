require 'uri'
include TimeagoHelper	 
class ContentController < ApplicationController
helper :Timeago 
	
	def index
		@pagesize=30
		@page = params[:page].to_i > 0 ? (params[:page].to_i) : 0
		@actived = {"home" => "active"}
		@posts = Post.find_by_sql(["select * , TIMESTAMPDIFF(HOUR, created_at, now()) t,vote v,(vote-1)/(POW((TIMESTAMPDIFF(HOUR, created_at,now())+2),1.5)) as r from posts order by r desc limit ?,?",@page*@pagesize,@pagesize])
	end

###单页
	def view
		@actived = {"reply" => "active"}
		@post = Post.find(params[:id])
		@title = @post.title + "-Zaozao.net"
		uid=0
		if session[:user_id]
			uid=session[:user_id]		
		end
		@body = build_tree(uid,@post.id)
	end

###最新	
	def last
		@pagesize=30
		@page = params[:page].to_i > 0 ? (params[:page].to_i) : 0
		@actived = {"last" => "active"}
		@posts = Post.find_by_sql(["select * from posts order by created_at desc limit ?,?",@page*@pagesize,@pagesize])	
		
	end
	
###按用户	
	def from
		@pagesize=30
		@page = params[:page].to_i > 0 ? (params[:page].to_i) : 0
		@account =Account.find_by_username(params[:id])
		@title = @account.username + "的投递 -Zaozao.net"
		
		if !@account		
			redirect_to("/404.html")
			return
		end
		
		@actived = {"from" => "active"}
		@posts = Post.find_by_sql(["select * from posts where username =? order by vote desc limit ?,?",@account.username,@page*@pagesize,@pagesize])	
		@logined = session[:user_name] == @account.username ? 1 : 0
	end

###按域名
	def domain
		@pagesize=30
		@page = params[:page].to_i > 0 ? (params[:page].to_i) : 0
		@link_t = params[:id].to_s.tr("_",".")
		@posts = Post.find_by_sql(["select * from posts where link_t =? order by vote desc limit ?,?",@link_t,@page*@pagesize,@pagesize])	
		
		if !@posts		
			redirect_to("/404.html")
			return
		end
		
		@actived = {"domain" => "active"}
	end
	
###投递文章
	def post
		@baseurl = params[:u]
		@basetitle = params[:t]
		
		if !session[:user_id]
			flash[:notice] = '<div class="status error">
							<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
							<p>请先登录.</p>
					</div>'
			redirect_to :controller=>"account",:action=>"login"
			return
		end

		@actived = {"post" => "active"}

		if request.post? 
				
				url = params[:link] 
				title = params[:title]
				text = params[:text]
				type = params[:type] 
				
				if type != 'link' && type != 'text'
					flash.now[:notice] = '<div class="status error">
									<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
									<p>未知的投递类型.</p>
							</div>'
					
					respond_to do |format|
					format.html 
					format.xml  { render :xml => @post
					}
					end
					return
				end
				
				if title == ''
						flash.now[:notice] = '<div class="status error">
										<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
										<p>标题不能为空.</p>
								</div>'
						
						respond_to do |format|
						format.html 
						format.xml  { render :xml => @post
						}
						end
						return
				end
				
				@post = Post.new	
				
				if type =="link"
												
					if url == '' || url == 'http://'
						flash.now[:notice] = '<div class="status error">
										<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
										<p>链接不能为空.</p>
								</div>'
						
						respond_to do |format|
						format.html 
						format.xml  { render :xml => @post
						}
						end
						return
					end
					
					uri = URI.parse(URI.encode(url))	
					
					if !uri.host	
						flash.now[:notice] = '<div class="status error">
										<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
										<p>链接有误.</p>
								</div>'
						
						respond_to do |format|
						format.html 
						format.xml  { render :xml => @post
						}
						end
						return
					end
					
					@post.link_t = uri.host
					@post.link = url
									
					if Post.find_by_link(url)
						flash.now[:notice] = '<div class="status error">
										<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
										<p>链接已存在.</p>
								</div>'
						
						respond_to do |format|
						format.html 
						format.xml  { render :xml => @post
						}
						end
						return
					end
					
				end
				
				if type =="text"
														
					if text == ''
						flash.now[:notice] = '<div class="status error">
										<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
										<p>文本不能为空.</p>
								</div>'
						
						respond_to do |format|
						format.html 
						format.xml  { render :xml => @post
						}
						end
						return
					end
							
					@post.link_t = "zaozao.net"
					@post.link = ""
					@post.text = text	
				end
							
			  
				@post.title = title
				@post.username = session[:user_name]
				@post.uid = session[:user_id]		
					
				if @post.save			
					if type =="text"
						post = Post.find(@post.id)
						post.link = "/content/view/"+@post.id.to_s
						post.save
					end
					account = Account.find(@post.uid)
					account.posts = account.posts+1
					account.save
							
					redirect_to ("/content/from/"+session[:user_name])
				else
					flash[:notice] = '<div class="status error">
						<p class="closestatus"><a href="#" onclick="close_by_class(\'status\')" title="Close">x</a></p>
						<p>提交出错了.</p>
					</div>'
					respond_to do |format|
					format.html 
	
					format.xml  { render :xml => @post
					}
					end
				end
					
		else #无请求
			@post = Post.new
			respond_to do |format|
			format.html 

			format.xml  { render :xml => @post
			}
			end
		end
		

	end

###about	
	def about
		@actived = {"about" => "active"}
		
	end


	protected
	@@body="" 

####生成树	
	def build_tree(uid,post_id,father_id=0,level=1)
	
		@trees = Reply.find(:all,:order=>"vote desc",:conditions => ["post_id =? and father =? ",post_id,father_id])	
		@trees.each do |tree|
		
		  l_s=''
		  l_e=''
		  l_d=''
		  (level-1).times do
				l_s += '<div class="level">'  
		  end
		   (level-1).times do
				l_e += '</div>'  
		  end
		  time=time_ago(tree.created_at)
		  if uid==tree.uid
		  	  l_d="<a href='javascript:void(0);' onclick='delone(\"reply\",#{tree.id})'>X</a>"	
		  end
		   @@body += "#{l_s}
		  		<div class='zao' id='reply_#{tree.id}'>
			    <div class='r_t'>
					<div class='r_l'>
					<span class='votebox'> <a href='javascript:void(0)' onClick='voteone(\"post\",<%=h post.id%>,\"add\")' class='vote'>▲</a><a href='javascript:void(0)'  onClick='voteone(\"post\",<%=h post.id%>,\"sub\")' class='vote'>▼</a> </span></div><div class='c_r'><p class='title'>#{tree.message}</a></p><p class='subtitle'> <a href='javascript:void(0)' onclick='replyto(#{tree.post_id},#{tree.id});'>回复</a> | 得<span id='vote_reply_#{tree.id}'>#{tree.vote}</span>分 | <a href='/content/from/#{tree.username}'>#{tree.username}</a> 投递于 #{time} #{l_d}</p>
						<div id='ipbox_#{tree.id}'></div>
					</div>	
				</div>	
				</div>
				<div class='clear'></div>
				#{l_e}"
		  build_tree(uid,post_id,tree.id,level+1)
		end
		return @@body
		
	end

	def authorize
	end
end
