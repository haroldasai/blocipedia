class WikiPolicy < ApplicationPolicy
  
  def create?
  	user.present?
  end	

  def update?
  	user.present?
  end

  def destroy?
  	user.present? && user.admin?
  end
end  	