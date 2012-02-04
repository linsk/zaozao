# Timego_helper.rb  
module TimeagoHelper  
   
  def time_ago(t)
  	  	 i =  Time.new.to_i - t.to_i
  	  	 s =''
  	  	 
  	  	 if i<60
  	  	 	s = "当前"
  	  	 elsif i<3600
  	  	 	s = (i/60).to_s + "分钟前"	  	 	
  	  	 elsif i< 86400	 
  	  	 	s = (i/3600).to_s + "小时前"
  	  	 else	 
  	  	 	s = (i/86400).to_s + "天前"
  	  	 end
  	  	 	 
  	  	 
  	  	 return s
  	  	 
  end
  
end 