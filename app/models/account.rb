require 'digest/md5'  
class Account < ActiveRecord::Base

	validates_presence_of :password,:message => "密码不能为空."
	validates_presence_of :username,:message => "用户名不能为空"
 
	validates_length_of :username,:maximum =>16,:message=>"用户名不能大于16个字符."   
	
	validates_uniqueness_of :username,:message => "该用户名已经被注册."

	def self.authenticate(login, pass) #用户名
    	account = self.find_by_username(login)
    	if account
    		pass = Digest::MD5.hexdigest(pass)
			if account.password != pass
			 	account=nil
		 	end
		end
		account
	end
	 
	def md5
		self.password = Digest::MD5.hexdigest(password)  
	end 
end
