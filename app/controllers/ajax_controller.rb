class AjaxController < ApplicationController
	include TimeagoHelper
	def update
		@post = Post.find_by_sql("select TIMESTAMPDIFF(HOUR, created_at, now()) t,vote v,(vote-1)/(POW((TIMESTAMPDIFF(HOUR, created_at,now())+2),1.5)) as r  from posts order by r desc limit 100")
		
		respond_to do |format|
		format.json  { render :json => @post }
		end
	end	

###回复		
	def reply
			uid=session[:user_id]
			cid=params[:cid] ? params[:cid] : 0
			faid=params[:faid] ? params[:faid] : 0 ;
			message=params[:message]
			
			if !uid
					@info='{"error":"请先登录"}'
					respond_to do |format|
					format.json  { render :json => @info }
					end
					return				
			end
			
			if message==''
					@info='{"error":"请输入点什么吧"}'
					respond_to do |format|
					format.json  { render :json => @info }
					end
					return				
			end
			
			post = Post.find_by_id(cid)
			if !post
					@info='{"error":"文章不存在"}'
					respond_to do |format|
					format.json  { render :json => @info }
					end
					return				
			end
			
			reply = Reply.new
			reply.post_id = cid
			reply.father = faid
			reply.uid = uid
			reply.message = message
			reply.username = session[:user_name]
			if reply.save
			@info='{"success":"1","name":"'+reply.username.to_s+'","vote":"'+reply.vote.to_s+'","cid":"'+reply.post_id.to_s+'","message":"'+reply.message.to_s+'","reid":"'+reply.id.to_s+'","time":"'+time_ago(reply.created_at).to_s+'"}'
			post.reply=post.reply+1
			post.save
					respond_to do |format|
					format.json  { render :json => @info }
					end
							
			end
			
			
		
	end
	
###+1	
	def voteone
		type_arr={"reply"=>1,"post"=>1}		
		
		if request.post?
				cid=params[:cid]
				type=params[:type]
				num=params[:num]
				uid=session[:user_id]
				@info=''

				if !uid
					@info='{"error":"请先登录"}'
					respond_to do |format|
					format.json  { render :json => @info }
					end
					return				
				end

				if !type_arr[type] 
					
					return				
				end	
				
				vd = Voterecord.find(:first,:conditions => ["cid = ? and uid = ? and votetype = ?", cid,uid,type])
				
				if vd
					@info='{"error":"已经投过票了"}'
					respond_to do |format|
					format.json  { render :json => @info }
					end
					return		
				end
							
				case type
					when "post"
						@post = Post.find(:first,:conditions => ["id=? ",cid])
						
						if !@post
							@info='{"error":"文章不存在"}'
							respond_to do |format|
							format.json  { render :json => @info }
							end
							return			
						end
						if num == "add"
							@post.vote = @post.vote + 1
						end
						if num == "sub"
							@post.vote = @post.vote < 1 ? 0 : @post.vote - 1
						end
						if @post.save
							voterecord = Voterecord.new
							voterecord.votetype = type
							voterecord.cid = cid
							voterecord.uid = uid
		
							voterecord.save
							@info='{"success":"'+@post.vote.to_s+'"}'
							respond_to do |format|
							format.json  { render :json => @info }
							end
							
						end
					when "reply"
						@reply= Reply.find(:first,:conditions => ["id=? ",cid])
						
						if !@reply
							@info='{"error":"回复不存在"}'
							respond_to do |format|
							format.json  { render :json => @info }
							end
							return			
						end
		
						
						if num == "add"
							@reply.vote = @reply.vote + 1
						end
						if num == "sub"
							@reply.vote = @reply.vote < 1 ? 0 : @reply.vote - 1
						end
						if @reply.save
							voterecord = Voterecord.new
							voterecord.votetype = type
							voterecord.cid = cid
							voterecord.uid = uid
		
							voterecord.save
							@info='{"success":"'+@reply.vote.to_s+'"}'
							respond_to do |format|
							format.json  { render :json => @info }
							end
							
						end
					
				end

				
		end
	end
	
	
	
###删除文章	
	def delone
		type_arr={"reply"=>1,"post"=>1}		
		cid=params[:cid]
		type=params[:type]
		uid=session[:user_id]
		
		if !uid
					@info='{"error":"请先登录"}'
					respond_to do |format|
					format.json  { render :json => @info }
					end
					return				
		end

		if !type_arr[type] 
			
			return				
		end	
		
		case type
				when "post"
				post = Post.find(:first,:conditions => ["id = ? and uid = ? ",cid,uid],:limit=>1)
				if post && post.uid == uid
					post.link = "#"
					post.link_t = "#"
					post.text = ""
					post.title = "自删"
					post.save
					
					@info='{"success":"删除成功"}'
							respond_to do |format|
							format.json  { render :json => @info }
							end
					return	
				else
					@info='{"error":"未找到"}'
					respond_to do |format|
					format.json  { render :json => @info }
					end
					return	
				end
								
				when "reply"
				reply = Reply.find(:first,:conditions => ["id = ? and uid = ? ",cid,uid],:limit=>1)
				if reply && reply.uid == uid				
					reply.message = "自删"
					reply.save
				
					@info='{"success":"删除成功"}'
							respond_to do |format|
							format.json  { render :json => @info }
							end
					return	
				else
					@info='{"error":"未找到"}'
					respond_to do |format|
					format.json  { render :json => @info }
					end
					return	
				end
		end
		
	end
	
end
