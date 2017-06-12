class UserPolicy < ApplicationPolicy
  
  def show?
  	user.id == record.id || user.admin?
  end	

end  